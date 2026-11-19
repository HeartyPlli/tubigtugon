import fs from 'node:fs/promises';
import path from 'node:path';
import { FileBlob, PresentationFile } from '@oai/artifact-tool';

async function writeBlob(filePath, blob) {
  await fs.writeFile(filePath, new Uint8Array(await blob.arrayBuffer()));
}

async function main() {
  const input = process.argv[2];
  const output = process.argv[3];
  await fs.mkdir(output, { recursive: true });
  const presentation = await PresentationFile.importPptx(await FileBlob.load(input));

  const content = await presentation.inspect({
    select: '$.slides[*]',
    include: [
      'id', 'index', 'layout', 'title',
      'elements.id', 'elements.kind', 'elements.name', 'elements.text',
      'elements.position', 'elements.style', 'elements.alt', 'notes.text',
    ],
  });
  await fs.writeFile(path.join(output, 'content.ndjson'), content.ndjson, 'utf8');

  const layoutInfo = await presentation.inspect({
    select: '$.slides[*]',
    include: ['id', 'index', 'layout', 'position'],
  });
  await fs.writeFile(path.join(output, 'slides.ndjson'), layoutInfo.ndjson, 'utf8');

  const summary = {
    slideCount: presentation.slides.items.length,
    slideSize: presentation.slideSize,
    masters: presentation.masters.items.map((master) => ({
      id: master.id,
      name: master.name,
    })),
    layouts: presentation.layouts.items.map((layout) => ({
      id: layout.id,
      name: layout.name,
      placeholders: layout.placeholders.summary(),
    })),
  };
  await fs.writeFile(path.join(output, 'summary.json'), JSON.stringify(summary, null, 2), 'utf8');

  for (const [index, slide] of presentation.slides.items.entries()) {
    await writeBlob(
      path.join(output, `slide-${String(index + 1).padStart(2, '0')}.png`),
      await presentation.export({ slide, format: 'png', scale: 1 }),
    );
    await fs.writeFile(
      path.join(output, `slide-${String(index + 1).padStart(2, '0')}.layout.json`),
      await (await slide.export({ format: 'layout', detail: 'full' })).text(),
      'utf8',
    );
  }
  await writeBlob(
    path.join(output, 'montage.webp'),
    await presentation.export({ format: 'webp', montage: true, scale: 1 }),
  );
  console.log(JSON.stringify(summary, null, 2));
}

main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
