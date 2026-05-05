# Blender Asset Pipeline

## Folder Roles

Use `source_assets/blender/` for editable `.blend` files.

Use `assets/models/` for exported game-ready models such as `.glb`.

This separation matters because Blender source files are for editing, while exported models are what Godot imports.

## Recommended Export Format

Use glTF binary:

```text
.glb
```

For this project, start with simple low-poly props:

- Target stand
- Crate
- Wall panel
- Floor tile
- Blaster model

## Naming

Use lowercase names with underscores:

```text
target_stand.blend
target_stand.glb
wall_panel_a.blend
wall_panel_a.glb
```

## Scale

Use Blender units as meters. Godot 3D units are also treated as meters, so a 2 meter wall in Blender should arrive as a 2 unit wall in Godot.

## Beginner Export Checklist

Before exporting:

- Apply transforms.
- Keep origin placement intentional.
- Name objects clearly.
- Use simple materials.
- Export selected objects when testing a single prop.
- Import into Godot and check scale before making many more assets.
