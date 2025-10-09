Index the entire codebase. read all the code and all the tests.
and for each directory, from the root to the deepest leaf. add a "context.md" that describes the project from that level of perspective.
e.g. in the root, context.md would likely be similar to the readme.
but in /src/something, context would describe what the code in that folder does, what are the key concepts, methods and types,  a form of quick lookup index for _you_ to understand the codebase.
include positive findings, negative findings, and any other insights that might be useful.

the reader of these context.md files are _you_ the AI agent. adapt them so that an AI agent could quicker get an idea of how the code works.

Also link from context.md to context.md if there is relations that are important to understand. contextual links between subsystems.

Basically, a search index for AI agents to easier navigate the code.

Update the agents.md to include that this information exists, and that you should always try to look at those files first, to get a quicker understanding of everything.
also update agents.md to update context.md in any folder where changes are made

Include information on which parts of the system is the least entangled with the rest.
what would be the easiest vs the hardest to migrate out to a modern environment.

suggestions on _how_ such migration could work, e.g. break out module xyz to a modern system, make old modules def and fgh call the new system using http. those changes would be made here and there.