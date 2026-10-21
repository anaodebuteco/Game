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

### 2026-10-20 — MVP em paisagem, qualidade com 3 presets manuais
- **Motivo:** reduzir o escopo do vertical slice. Retrato e qualidade automática ficam para depois.

## Decisões em aberto

| Decisão | Prazo | Observação |
|---|---|---|
| Versão exata da Godot 4.x | Etapa 0A | Fixar e registrar aqui. Deve ser a mesma no Windows e no Codemagic. |
| Renderer (Compatibility ou Mobile) | Etapa 0B | Decidir pelo teste no iPhone. |
