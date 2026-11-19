from __future__ import annotations

import json
import sys
from pathlib import Path

from docx import Document


def extract(path: Path) -> dict:
    document = Document(path)
    data = {
        "path": str(path),
        "paragraphs": [],
        "tables": [],
        "sections": [],
        "inline_shapes": len(document.inline_shapes),
    }
    for index, paragraph in enumerate(document.paragraphs):
        if paragraph.text.strip():
            data["paragraphs"].append(
                {
                    "index": index,
                    "style": paragraph.style.name if paragraph.style else None,
                    "text": paragraph.text,
                }
            )
    for table_index, table in enumerate(document.tables):
        rows = []
        for row_index, row in enumerate(table.rows):
            rows.append(
                {
                    "index": row_index,
                    "cells": [cell.text.replace("\n", " / ") for cell in row.cells],
                }
            )
        data["tables"].append({"index": table_index, "rows": rows})
    for index, section in enumerate(document.sections):
        data["sections"].append(
            {
                "index": index,
                "width": section.page_width,
                "height": section.page_height,
                "top_margin": section.top_margin,
                "bottom_margin": section.bottom_margin,
                "left_margin": section.left_margin,
                "right_margin": section.right_margin,
            }
        )
    return data


def main() -> None:
    output_dir = Path(sys.argv[1])
    output_dir.mkdir(parents=True, exist_ok=True)
    for raw_path in sys.argv[2:]:
        path = Path(raw_path)
        data = extract(path)
        output_path = output_dir / f"{path.stem}.json"
        output_path.write_text(json.dumps(data, ensure_ascii=False, indent=2), encoding="utf-8")
        print(f"{path.name}: {len(data['paragraphs'])} non-empty paragraphs, "
              f"{len(data['tables'])} tables, {data['inline_shapes']} inline shapes")


if __name__ == "__main__":
    main()
