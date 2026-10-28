# Registro de decisões

Registre aqui cada decisão técnica ou de design, com data e motivo. Não apague decisões antigas: se uma mudar, acrescente uma nova entrada que a substitua.

## Decisões fechadas

### 2026-10-20 — Visual 2D com estética isométrica
- **Motivo:** mais rápido de produzir por um desenvolvedor solo, mais leve no iPhone, menos minutos de build e mais fácil de depurar sem Xcode.
- **Reavaliar apenas se:** houver motivo concreto para 3D.

### 2026-10-20 — Mira automática assistida no toque
- **Resultado:** o ataque mira no inimigo mais próximo (ou no mais alinhado à direção do movimento). No desktop, o mouse pode fornecer a direção.
- **Motivo:** o jogo é centrado em posicionamento, esquiva e habilidades; menos um controle na tela do celular.
- **Reavaliar apenas se:** os testes mostrarem necessidade real de mira manual.

### 2026-10-20 — Build iOS no Codemagic
- **Resultado:** Codemagic, conta pessoal gratuita (500 minutos de macOS por mês, valor conferido em outubro de 2026), repositório privado, configuração em `codemagic.yaml`. O `.ipa` é gerado sem assinatura e instalado por AltStore ou Sideloadly.
- **Alternativa de reserva:** GitHub Actions com repositório público.
- **Motivo:** sem custo, aceita repositório privado e usa máquinas Apple M2.
- **Atualização:** a parte do repositório privado foi substituída pela entrada de 2026-10-27 abaixo.

### 2026-10-20 — MVP em paisagem, qualidade com 3 presets manuais
- **Motivo:** reduzir o escopo do vertical slice. Retrato e qualidade automática ficam para depois.

### 2026-10-21 — Versão da Godot: 4.7.2 estável (Standard, sem .NET)
- **Resultado:** Godot 4.7.2-stable oficial (Standard). Caminho local no Windows: `C:\Users\Pedro\Desktop\Godot\Godot_v4.7.2-stable_win64_console.exe`. No Codemagic (macOS), será utilizada a mesma versão oficial (4.7.2-stable).
- **Motivo:** versão estável sem dependência do runtime C#/.NET, viabilizando exportação limpa e direta para iOS via GDScript.

### 2026-10-21 — Renderer inicial do projeto: Compatibility
- **Resultado:** `project.godot` configurado inicialmente com o renderer `gl_compatibility`.
- **Motivo:** menor consumo inicial de recursos e maior compatibilidade base; a escolha definitiva entre Compatibility e Mobile no iOS será validada na Etapa 0B com testes no iPhone físico.

### 2026-10-27 — Renderer mobile definido explicitamente como Compatibility
- **Resultado:** `project.godot` passa a ter também `renderer/rendering_method.mobile="gl_compatibility"`, além de `renderer/rendering_method="gl_compatibility"`.
- **Observação técnica:** inspecionado com a própria Godot 4.7.2, o padrão mobile da engine é `mobile`. Foi sobrescrito para `gl_compatibility` para o primeiro build de teste no iPhone.
- **Próximo passo:** na Etapa 0B, testar Compatibility primeiro e depois Mobile, e escolher pelo resultado no aparelho.

### 2026-10-27 — Repositório é público
- **Resultado:** `anaodebuteco/Game` é **público** (verificado em 27/10 sem login: HTTP 200). Isso substitui o "repositório privado" da entrada de 2026-10-20 e do `CONTINUIDADE.md`.
- **Consequência:** código e histórico ficam visíveis a qualquer pessoa. Nenhum segredo pode entrar no repositório (credenciais da Apple, chaves, senhas). O build atual não usa nenhum.

### 2026-10-27 — Workflow `ios-sideload` no Codemagic, sem assinatura e com início manual
- **Resultado:** `codemagic.yaml` na raiz, workflow `ios-sideload`. Exporta o projeto Xcode com a Godot 4.7.2 em modo headless, compila com `xcodebuild archive` sem assinatura e empacota `Payload` em um `.ipa`. Instalação no iPhone por AltStore ou Sideloadly.
- **Sem `triggering`:** o build só roda quando iniciado manualmente no Codemagic, para proteger os 500 minutos mensais. O push sozinho não dispara build.
- **Preset iOS (`export_presets.cfg`, versionado):** `application/export_project_only=true` e Team ID de teste `ABCDE12345`. Não é um Team ID real. Que a Godot o aceita ainda não foi validado.
- **Não validado:** o build no Codemagic ainda não rodou. A flag de exportação headless, o nome do scheme do Xcode e o caminho do `.app` no `xcarchive` são hipóteses até o primeiro log.

## Decisões em aberto

| Decisão | Prazo | Observação |
|---|---|---|
| Renderer definitivo no iOS (Compatibility ou Mobile) | Etapa 0B | Decidir após testes reais no iPhone. |
| A Godot aceita o Team ID de teste `ABCDE12345` na exportação headless? | Etapa 0B | Validar no primeiro build do Codemagic. |