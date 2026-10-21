# CLAUDE.md

Roguelike sci-fi isométrico 2D em Godot 4.x (GDScript). Ambiente de desenvolvimento: Windows com PowerShell. Plataforma de destino: iPhone primeiro, Android depois. Não há Mac: as builds iOS saem do Codemagic (macOS na nuvem) e são instaladas no iPhone por sideload.

## Leia antes de qualquer tarefa

- `docs/REQUIREMENTS.md`: especificação completa, etapas e critérios de aceitação.
- `docs/DECISIONS.md`: decisões já tomadas e versões fixadas.

## Decisões fechadas

- 2D com visual isométrico.
- Mira automática assistida no toque; mouse no desktop.
- Build iOS no Codemagic com repositório privado, configurado em `codemagic.yaml`.
- MVP em paisagem apenas. Qualidade visual com 3 presets manuais.

## Regras de trabalho

1. Trabalhe somente na etapa que o usuário autorizar (seção 15 do documento). Não adiante etapas.
2. Leia os arquivos existentes antes de alterar. Faça mudanças mínimas e não reescreva o projeto.
3. Não invente APIs da Godot nem opções do Codemagic. Confirme na documentação da versão fixada.
4. Use GDScript tipado e scripts pequenos. Não adicione plugins sem justificativa registrada em `docs/DECISIONS.md`.
5. Centralize regras de dano, atributos e compatibilidade de itens. A entrada (teclado, mouse, toque) vira intenções de gameplay, como `move_direction` e `aim_direction`.
6. Não crie arquivos vazios só para preencher a estrutura.
7. Execute as verificações disponíveis e informe exatamente o que foi e o que não foi testado. Nunca declare sucesso sem verificar os critérios de aceitação.
8. O fluxo iOS só conta como funcional depois que o usuário confirmar que o app abriu no iPhone.

## Segurança e limites

- Não execute `git push`, não dispare builds e não publique nada sem autorização explícita naquela ocasião.
- Nunca peça, leia nem grave credenciais (Apple ID, tokens, senhas) no repositório, no `codemagic.yaml` ou em qualquer arquivo.
- Não altere configurações globais do sistema nem apague dados do usuário sem autorização.

## Commits

Faça um commit ao final de cada etapa, com mensagens no formato `tipo: descrição` (por exemplo `feat: implement player movement`, `ci: add unsigned iOS build`, `chore: initialize Godot project`).

## Ao terminar cada tarefa

Informe os arquivos modificados, os testes executados e seus resultados, as limitações e o próximo passo recomendado.
