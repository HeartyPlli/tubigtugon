from __future__ import annotations

from pathlib import Path

from docx import Document
from docx.enum.section import WD_SECTION_START
from docx.enum.table import WD_CELL_VERTICAL_ALIGNMENT, WD_TABLE_ALIGNMENT
from docx.enum.text import WD_ALIGN_PARAGRAPH
from docx.oxml import OxmlElement
from docx.oxml.ns import qn
from docx.shared import Inches, Pt, RGBColor


OUTPUT_DIR = Path(__file__).resolve().parents[2] / "outputs"
FONT = "Arial"
BLUE = "1769E0"
DARK_BLUE = "0E4EA8"
LIGHT_BLUE = "EAF3FF"
PALE_BLUE = "F5F9FF"
LIGHT_GRAY = "D9D9D9"
TEXT = "17212B"
MUTED = "52606D"


def set_cell_shading(cell, fill: str) -> None:
    tc_pr = cell._tc.get_or_add_tcPr()
    shd = tc_pr.find(qn("w:shd"))
    if shd is None:
        shd = OxmlElement("w:shd")
        tc_pr.append(shd)
    shd.set(qn("w:fill"), fill)


def set_cell_margins(cell, top=110, start=120, bottom=110, end=120) -> None:
    tc = cell._tc
    tc_pr = tc.get_or_add_tcPr()
    tc_mar = tc_pr.first_child_found_in("w:tcMar")
    if tc_mar is None:
        tc_mar = OxmlElement("w:tcMar")
        tc_pr.append(tc_mar)
    for margin, value in (("top", top), ("start", start), ("bottom", bottom), ("end", end)):
        node = tc_mar.find(qn(f"w:{margin}"))
        if node is None:
            node = OxmlElement(f"w:{margin}")
            tc_mar.append(node)
        node.set(qn("w:w"), str(value))
        node.set(qn("w:type"), "dxa")


def set_table_borders(table, color=LIGHT_GRAY, size="6") -> None:
    tbl_pr = table._tbl.tblPr
    borders = tbl_pr.first_child_found_in("w:tblBorders")
    if borders is None:
        borders = OxmlElement("w:tblBorders")
        tbl_pr.append(borders)
    for edge in ("top", "left", "bottom", "right", "insideH", "insideV"):
        tag = f"w:{edge}"
        element = borders.find(qn(tag))
        if element is None:
            element = OxmlElement(tag)
            borders.append(element)
        element.set(qn("w:val"), "single")
        element.set(qn("w:sz"), size)
        element.set(qn("w:space"), "0")
        element.set(qn("w:color"), color)


def set_repeat_table_header(row) -> None:
    tr_pr = row._tr.get_or_add_trPr()
    tbl_header = OxmlElement("w:tblHeader")
    tbl_header.set(qn("w:val"), "true")
    tr_pr.append(tbl_header)


def set_run_font(run, size=None, bold=None, color=None) -> None:
    run.font.name = FONT
    run._element.get_or_add_rPr().rFonts.set(qn("w:ascii"), FONT)
    run._element.get_or_add_rPr().rFonts.set(qn("w:hAnsi"), FONT)
    if size is not None:
        run.font.size = Pt(size)
    if bold is not None:
        run.bold = bold
    if color is not None:
        run.font.color.rgb = RGBColor.from_string(color)


def configure_document(title: str, intro: str) -> Document:
    document = Document()
    section = document.sections[0]
    section.page_width = Inches(8.5)
    section.page_height = Inches(11)
    section.top_margin = Inches(0.7)
    section.bottom_margin = Inches(0.7)
    section.left_margin = Inches(0.72)
    section.right_margin = Inches(0.72)

    styles = document.styles
    normal = styles["Normal"]
    normal.font.name = FONT
    normal._element.rPr.rFonts.set(qn("w:ascii"), FONT)
    normal._element.rPr.rFonts.set(qn("w:hAnsi"), FONT)
    normal.font.size = Pt(10.5)
    normal.font.color.rgb = RGBColor.from_string(TEXT)
    normal.paragraph_format.space_after = Pt(6)
    normal.paragraph_format.line_spacing = 1.12

    title_style = styles["Title"]
    title_style.font.name = FONT
    title_style._element.rPr.rFonts.set(qn("w:ascii"), FONT)
    title_style._element.rPr.rFonts.set(qn("w:hAnsi"), FONT)
    title_style.font.size = Pt(23)
    title_style.font.bold = True
    title_style.font.color.rgb = RGBColor(0, 0, 0)
    title_style.paragraph_format.space_after = Pt(10)

    for style_name, size in (("Heading 1", 16), ("Heading 2", 13)):
        style = styles[style_name]
        style.font.name = FONT
        style._element.rPr.rFonts.set(qn("w:ascii"), FONT)
        style._element.rPr.rFonts.set(qn("w:hAnsi"), FONT)
        style.font.size = Pt(size)
        style.font.bold = True
        style.font.color.rgb = RGBColor(0, 0, 0)
        style.paragraph_format.space_before = Pt(10)
        style.paragraph_format.space_after = Pt(5)

    paragraph = document.add_paragraph(style="Title")
    paragraph.add_run(title)
    intro_paragraph = document.add_paragraph(intro)
    intro_paragraph.paragraph_format.space_after = Pt(14)
    return document


def add_table(document: Document, headers: list[str], rows: list[list[str]], widths: list[float]) -> None:
    table = document.add_table(rows=1, cols=len(headers))
    table.alignment = WD_TABLE_ALIGNMENT.CENTER
    table.autofit = False
    set_table_borders(table)
    header_row = table.rows[0]
    set_repeat_table_header(header_row)
    for index, header in enumerate(headers):
        cell = header_row.cells[index]
        cell.width = Inches(widths[index])
        cell.vertical_alignment = WD_CELL_VERTICAL_ALIGNMENT.CENTER
        set_cell_shading(cell, DARK_BLUE)
        set_cell_margins(cell)
        paragraph = cell.paragraphs[0]
        paragraph.alignment = WD_ALIGN_PARAGRAPH.LEFT
        paragraph.paragraph_format.space_after = Pt(0)
        run = paragraph.add_run(header)
        set_run_font(run, size=9.5, bold=True, color="FFFFFF")

    for row_index, values in enumerate(rows):
        row = table.add_row()
        for index, value in enumerate(values):
            cell = row.cells[index]
            cell.width = Inches(widths[index])
            cell.vertical_alignment = WD_CELL_VERTICAL_ALIGNMENT.CENTER
            set_cell_margins(cell)
            if row_index % 2 == 1:
                set_cell_shading(cell, PALE_BLUE)
            paragraph = cell.paragraphs[0]
            paragraph.paragraph_format.space_after = Pt(0)
            paragraph.paragraph_format.line_spacing = 1.05
            run = paragraph.add_run(value)
            set_run_font(run, size=9.2, color=TEXT)
    document.add_paragraph().paragraph_format.space_after = Pt(0)


def add_bullets(document: Document, items: list[str]) -> None:
    for item in items:
        paragraph = document.add_paragraph(style="List Bullet")
        paragraph.paragraph_format.left_indent = Inches(0.22)
        paragraph.paragraph_format.first_line_indent = Inches(-0.12)
        paragraph.paragraph_format.space_after = Pt(4)
        run = paragraph.add_run(item)
        set_run_font(run, size=10.5, color=TEXT)


def add_footer(document: Document, text: str) -> None:
    footer = document.sections[0].footer
    paragraph = footer.paragraphs[0]
    paragraph.alignment = WD_ALIGN_PARAGRAPH.CENTER
    paragraph.text = text
    for run in paragraph.runs:
        set_run_font(run, size=8, color=MUTED)


def build_phase5() -> None:
    document = configure_document(
        "Phase 5 TubigTugon User Flow",
        "The updated flow covers the resident and barangay staff experiences in the working Flutter prototype. "
        "Residents can check water information or submit a concern, while staff can publish notices, manage reports, "
        "update the schedule, and prepare a printable PDF advisory.",
    )
    document.add_heading("Resident Flow", level=1)
    add_table(
        document,
        ["Step", "Resident action", "System response"],
        [
            ["1", "Open TubigTugon.", "The Home screen shows the current schedule, latest notice, and Report button."],
            ["2", "Choose Bisaya, English, or Filipino if needed.", "The visible labels change immediately while the resident stays on the same screen."],
            ["3A", "Read the schedule and latest notice.", "The screen shows the posted status, date, and confirmed return time when available."],
            ["3B", "Select Report or the Report a Problem button.", "The short report form opens."],
            ["4", "Select a location and problem type. Add details, contact method, or name if desired.", "Required selections are checked before submission. Optional fields may remain blank."],
            ["5", "Select Submit Report.", "The report enters the staff report list with a New status."],
            ["6", "Read the confirmation and select Done.", "The dialog closes and the form resets for a future report."],
        ],
        [0.55, 2.45, 3.9],
    )

    document.add_heading("Barangay Staff Flow", level=1)
    add_table(
        document,
        ["Step", "Staff action", "System response"],
        [
            ["1", "Tap the TubigTugon logo on the resident screen.", "The Staff Login screen opens without placing an Admin tab in the resident navigation."],
            ["2", "Enter the prototype staff credentials and log in.", "The Updates screen opens after successful validation. Incorrect credentials show an error."],
            ["3", "Select a water status, write a notice, and optionally add a confirmed return time.", "The new notice appears immediately on the resident Home screen and in Published Updates."],
            ["4", "Select Reports.", "Submitted concerns appear with location, problem, details, contact preference, and status."],
            ["5", "Change a report to New, In Progress, or Resolved.", "The status updates in the in-memory report list."],
            ["6", "Select Schedule, choose start and end times, and save.", "The resident Home screen immediately shows the updated schedule."],
            ["7", "Select Print Advisory or Save PDF from Updates.", "TubigTugon generates an A4 advisory containing the schedule, notices, return times, and generation date."],
            ["8", "Log out and confirm.", "The staff area closes and the resident interface returns."],
        ],
        [0.55, 2.45, 3.9],
    )

    document.add_heading("Navigation and Data Rules", level=1)
    add_bullets(
        document,
        [
            "Resident navigation contains only Home and Report to reduce confusion for older users.",
            "The logo provides staff access, while staff tools use Updates, Reports, and Schedule tabs.",
            "The selected language applies across resident screens, staff screens, and the generated PDF advisory.",
            "Prototype data remains in memory and resets when the application restarts because no database is connected.",
        ],
    )
    add_footer(document, "TubigTugon Phase 5 Updated User Flow")
    document.save(OUTPUT_DIR / "Phase5_UserFlow_Updated.docx")


def build_phase6() -> None:
    document = configure_document(
        "Phase 6 TubigTugon Functional Prototype Screens",
        "The prototype uses large text, clear actions, strong contrast, and short forms for residents aged 50 to 77. "
        "The screen specification below replaces the earlier four-screen concept and reflects the complete Flutter implementation.",
    )
    document.add_heading("Resident Screens", level=1)
    add_table(
        document,
        ["Screen", "Purpose", "Main elements", "Next action"],
        [
            ["1 Home Dashboard", "Show water information immediately.", "Current schedule, latest notice, return time, report button, offline guidance, language menu.", "Read the notice or open Report."],
            ["2 Report a Problem", "Collect a short resident concern.", "Location and problem dropdowns, optional details, contact preference, optional name, submit button.", "Submit the report."],
            ["3 Report Confirmation", "Confirm that the concern reached staff.", "Success icon, short confirmation message, Done button.", "Close the dialog. The form resets."],
            ["4 Language Menu", "Support Bisaya, English, and Filipino.", "Current-language indicator and three language choices.", "Select a language and remain on the current screen."],
        ],
        [1.25, 1.65, 2.85, 1.15],
    )

    document.add_heading("Barangay Staff Screens", level=1)
    add_table(
        document,
        ["Screen", "Purpose", "Main elements", "Next action"],
        [
            ["5 Staff Login", "Limit management tools to staff.", "TubigTugon logo and name, username, password, visibility control, login button, error message.", "Enter valid credentials."],
            ["6 Updates and PDF", "Publish notices and prepare a printable advisory.", "Status choices, notice field, confirmed return switch, publish button, Print Advisory, Save PDF, update history.", "Publish, print, save, or delete an update."],
            ["7 Resident Reports", "Review concerns sent by residents.", "Problem, location, details, name, contact preference, date, and status selector.", "Set the report status."],
            ["8 Water Schedule", "Maintain the active distribution time.", "Current schedule, start and end time selectors, validation, save button.", "Save the revised schedule."],
        ],
        [1.25, 1.65, 2.85, 1.15],
    )

    document.add_heading("Printable Water Advisory", level=1)
    add_table(
        document,
        ["PDF element", "Content"],
        [
            ["Header", "TubigTugon name and Purok 1, Barangay Kauswagan."],
            ["Schedule", "Current start and end time shown prominently."],
            ["Notices", "All published statuses and messages, including confirmed return times when available."],
            ["Record details", "Posting date, generation date, and page number."],
            ["Output actions", "Open the system print dialog or save/share the generated PDF file."],
        ],
        [1.7, 5.2],
    )

    document.add_heading("Accessibility and Interaction Requirements", level=1)
    add_bullets(
        document,
        [
            "Use readable labels and body text at approximately 16 to 18 logical pixels in the mobile interface.",
            "Keep primary buttons at least 52 to 56 logical pixels high and provide clear success or error feedback.",
            "Show a confirmed return time only when staff explicitly enable it.",
            "Keep printed notices and direct announcements available for households without reliable internet.",
        ],
    )
    add_footer(document, "TubigTugon Phase 6 Updated Screen Specification")
    document.save(OUTPUT_DIR / "Phase6_WireframeSection_Updated.docx")


def build_phase7() -> None:
    document = configure_document(
        "Phase 7 TubigTugon Cognitive Walkthrough",
        "The walkthrough evaluates two important tasks in the functional prototype: submitting a resident report and preparing a printable staff advisory. "
        "The review focuses on whether older residents and barangay staff can identify the correct action, predict the result, and understand the system feedback.",
    )
    document.add_heading("Task 1 Report a Water Problem", level=1)
    add_table(
        document,
        ["Step", "Action", "Expected result", "Finding"],
        [
            ["1", "Select Report from the bottom navigation or Report a Problem on Home.", "The report form opens.", "Yes. Both actions use direct wording and a campaign icon."],
            ["2", "Select the location and problem type.", "The required fields contain the chosen answers.", "Yes. Dropdowns reduce typing and use familiar options."],
            ["3", "Add optional details, contact preference, or name, then select Submit Report.", "The system validates required selections and stores the report.", "Yes. Optional labels reduce privacy concerns and one primary button ends the form."],
            ["4", "Read the confirmation and select Done.", "The dialog closes and the form resets.", "Yes. The success icon and short message confirm completion without requiring another screen."],
        ],
        [0.45, 2.45, 2.2, 1.8],
    )

    document.add_heading("Task 2 Print or Save a Water Advisory", level=1)
    add_table(
        document,
        ["Step", "Action", "Expected result", "Finding"],
        [
            ["1", "Tap the logo, enter staff credentials, and log in.", "The staff Updates screen opens.", "Yes. The logo is a consistent entry point and invalid credentials show a clear error."],
            ["2", "Confirm the current schedule and published notices.", "The staff sees the same data that will appear in the advisory.", "Yes. The export card explains that both schedule and notices are included."],
            ["3A", "Select Print Advisory.", "The system creates the PDF and opens the device print dialog.", "Yes. The printer icon and label match the expected result."],
            ["3B", "Select Save PDF.", "The system creates an A4 PDF and opens the device save or share options.", "Yes. The download icon distinguishes this action from printing."],
            ["4", "Review the generated advisory.", "The PDF shows the schedule, notices, confirmed return times, and generation date.", "Yes. The schedule receives the strongest visual emphasis and the notice list remains readable."],
        ],
        [0.45, 2.45, 2.2, 1.8],
    )

    document.add_heading("Walkthrough Findings", level=1)
    add_table(
        document,
        ["Finding", "Evidence", "Recommended follow-up"],
        [
            ["Resident reporting is direct.", "The form requires only location and problem type. Other fields remain optional.", "Test dropdown wording with residents aged 50 to 77."],
            ["Staff access stays out of the resident navigation.", "The logo opens the login screen, while Home and Report remain the only resident tabs.", "Add a short staff-access note to the administrator guide."],
            ["PDF export supports online and printed communication.", "The advisory combines the active schedule and notices in one A4 document.", "Test printing on the barangay's actual printer and phone."],
            ["The prototype provides clear feedback.", "Dialogs, snackbars, validation messages, and status changes acknowledge important actions.", "Conduct observation-based usability testing and record completion time and errors."],
        ],
        [1.65, 2.75, 2.5],
    )

    document.add_heading("Conclusion", level=1)
    document.add_paragraph(
        "The walkthrough indicates that the main resident and staff tasks have visible actions, predictable results, and understandable feedback. "
        "The next evaluation should involve representative residents and barangay staff using the application on a phone and printing one sample advisory."
    )
    add_footer(document, "TubigTugon Phase 7 Updated Cognitive Walkthrough")
    document.save(OUTPUT_DIR / "Phase7_CognitiveWalkthrough_Updated.docx")


def main() -> None:
    OUTPUT_DIR.mkdir(parents=True, exist_ok=True)
    build_phase5()
    build_phase6()
    build_phase7()
    for name in (
        "Phase5_UserFlow_Updated.docx",
        "Phase6_WireframeSection_Updated.docx",
        "Phase7_CognitiveWalkthrough_Updated.docx",
    ):
        print(OUTPUT_DIR / name)


if __name__ == "__main__":
    main()
