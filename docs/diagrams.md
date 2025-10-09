
# You may use the following base types of diagrams

1. Mermaid.JS
2. Excalidraw
3. Vega

## Mermaid.JS

This is the main diagram type.

### Styling / Colors

- For styling, colors, always ensure that background colors work well with foreground colors. e.g  `style THING fill:#1168bd,color:#ffffff` or `style THING fill:#8db33f,color:#000000`, select black or white text based on background brightness.
- For diagrams that do not support foreground color change, use colors that are around RGB 128,128,128 in intensity, as that works for both light and dark themes.
- for any type of diagram, if there are more than 25 arrows, or 12 participants, the diagram is likely too cluttered, consider breaking it down into parts. or evaluate if all items are on the correct level of abstraction.

### Graphs

For graph/flowchart diagrams, prefer LR layout.
For request response scenarios. model the arrows as:
```
A --->|Some Request| B
A <-.-|Some Response| B
```
This allows the layout engine to understand the direction of the data flow.

### Sequence Diagrams

- Aviod special characters like { ( or names like "node", pay attention to what you may use here.
- Avoid more than 10 participants in sequence diagrams, if there are more, the diagram is probably at the wrong level of abstraction.
- For styling sequence diagrams, use RGBA for background colors and set the alpha value to 0.1. this is so colors works in both light and dark mode.

### C4 Diagrams
These are more niche, but useful for documentation.
avoid unless explicitly asked for/in requirements.

#### C4Context
#### C4Container
#### C4Component
#### C4Dynamic
#### C4Deployment

