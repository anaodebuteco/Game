# Documento de Requisitos e Plano Técnico — Projeto Roguelike Sci-Fi para iOS

**Versão:** 1.2
**Status:** Planejamento aprovado; implementação ainda não iniciada
**Engine:** Godot 4.x, versão estável fixada no projeto
**Linguagem:** GDScript
**Ambiente principal:** Windows
**Assistente de programação:** Claude Code via terminal do Windows
**Plataforma inicial de validação:** Windows
**Plataforma de destino:** iPhone / iOS (Android depois)
**Escopo:** Vertical slice jogável, sem multiplayer e sem monetização no MVP
**Restrição de orçamento:** sem Mac próprio e sem gastos recorrentes nesta fase; build iOS por serviços gratuitos na nuvem e instalação por sideload

## Histórico de revisões

**v1.2** — decisões fechadas e ajustes de consistência:

- Fechadas: 2D com visual isométrico, mira automática assistida no toque (mouse no desktop) e Codemagic como serviço de build (registradas em `docs/DECISIONS.md`).
- Referências a `docs/TECHNICAL_PLAN.md` removidas: este documento é a especificação única.
- Configuração de CI passa a ser `codemagic.yaml` (GitHub Actions fica só como alternativa de reserva).
- Adicionado `CLAUDE.md` na raiz do projeto.

**v1.1** — alterações em relação à v1.0:

- Seção 14 reescrita: fluxo de build iOS 100% gratuito (CI em macOS na nuvem + AltStore/Sideloadly), sem Mac alugado.
- Nova Etapa 0B: prova do fluxo iOS com um projeto mínimo, antes de qualquer gameplay.
- MVP em **paisagem apenas**; retrato passa para pós-MVP (a arquitetura de UI deve continuar adaptável).
- Qualidade visual do MVP reduzida a presets manuais; modo automático/adaptativo passa para pós-MVP.
- Restrições de equipamento são testadas com uma classe fictícia, já que só há uma personagem jogável.
- Renderer, 2D/3D e modelo de mira passam a ter prazo de decisão (seção 20).
- Regras de commit e push ajustadas ao fluxo de CI; prompts do Claude Code atualizados.

---

## 1. Visão geral do projeto

### 1.1 Conceito

Criar um roguelike de ação e estratégia em um universo sci-fi hostil, com câmera isométrica, combate híbrido e dificuldade elevada.

O jogador controla personagens permanentes, cada um com sua própria identidade mecânica, especialização, equipamentos exclusivos e possibilidades de build. Durante as missões, o jogador conquista melhorias temporárias. Entre as missões, desenvolve sua conta, desbloqueia possibilidades e fortalece sua compreensão dos sistemas do jogo.

A experiência deve recompensar domínio de mecânicas, planejamento, posicionamento e decisões difíceis, em vez de depender exclusivamente de reflexos ou de acumular atributos.

### 1.2 Pilares de design

1. **Personagens permanentes:** cada personagem possui identidade, progressão e estilo de jogo próprios.
2. **Builds especializadas:** equipamentos e habilidades são associados a classes ou arquétipos. Não será possível equipar indiscriminadamente qualquer item.
3. **Combate híbrido:** combinação de ação em tempo real, posicionamento, habilidades com recarga e decisões táticas.
4. **Risco real:** erros custam recursos, oportunidades ou o sucesso da missão.
5. **Progressão em duas camadas:** melhorias durante a expedição e desenvolvimento permanente fora dela.
6. **Apresentação premium:** interface refinada, efeitos legíveis, animações responsivas, boa direção de arte e feedback audiovisual consistente.
7. **Controles adaptáveis:** controles por toque e desktop separados da lógica de combate. O MVP usa paisagem; o retrato entra depois, sem reescrever o gameplay.
8. **Escopo disciplinado:** construir uma pequena experiência completa antes de ampliar conteúdo.

### 1.3 Premissa narrativa

A humanidade mantém postos avançados em regiões espaciais contaminadas por uma tecnologia desconhecida. Uma organização envia agentes especializados para recuperar artefatos, eliminar ameaças e investigar instalações abandonadas.

O jogador pertence a uma unidade de recuperação de elite. Cada missão representa uma incursão em uma instalação hostil.

A narrativa deve ser apresentada inicialmente por diálogos curtos, registros encontrados e descrições de equipamentos. Não desenvolver uma campanha cinematográfica extensa no MVP.

O universo, os nomes definitivos e a história detalhada podem ser revisados após a validação da jogabilidade.

---

## 2. Definição do MVP

O MVP é uma demonstração jogável que valida o núcleo do jogo. Não é a versão final comercial.

### 2.1 Conteúdo obrigatório

- Uma personagem jogável inicial.
- Uma arena ou instalação sci-fi isométrica.
- Um sistema funcional de movimentação.
- Um ataque básico e pelo menos uma habilidade especial.
- Dois tipos de inimigos com comportamentos diferentes.
- Uma sala de combate e uma sala de recompensa.
- Um chefe simples ou inimigo de elite.
- Três escolhas de melhoria durante a missão.
- Um conjunto inicial de equipamentos com restrições de build.
- Uma missão com início, progressão e conclusão.
- Condições claras de vitória e derrota.
- Uma tela de resultado.
- Um sistema mínimo de progressão permanente salvo localmente.
- Interface funcional em **paisagem**.
- Controles para mouse/teclado e toque.
- Configurações básicas de áudio, **três presets manuais de qualidade** e vibração quando suportada.
- Execução estável no Windows e **build iOS gerada pelo fluxo de CI gratuito (seção 14) e instalável em iPhone por sideload**.

### 2.2 Fora do escopo inicial

Não implementar antes da validação do vertical slice:

- Multiplayer ou cooperativo.
- PvP.
- Servidores próprios.
- Login, contas online ou sincronização em nuvem.
- Monetização, anúncios, loja de compras ou passe de batalha.
- Dezenas de personagens.
- Geração procedural complexa.
- Mundo aberto.
- Narrativa cinematográfica extensa.
- Inventário com centenas de itens.
- Árvores de habilidades gigantescas.
- Fabricação de itens ou economia avançada.
- Dependências de serviços externos (o CI de build é ferramenta de desenvolvimento, não dependência do jogo).
- Sistemas de analytics que enviem dados pessoais.
- **Layout em retrato.**
- **Qualidade visual automática ou adaptativa.**

A arquitetura deve permitir expansão, mas não deve antecipar sistemas complexos sem necessidade comprovada.

---

## 3. Loop principal de gameplay

O loop principal será:

1. Escolher uma personagem disponível.
2. Conferir atributos, equipamentos e habilidades.
3. Iniciar uma incursão.
4. Entrar em uma sala de combate.
5. Posicionar-se, atacar, esquivar e utilizar habilidades.
6. Derrotar inimigos e coletar recursos.
7. Escolher uma melhoria temporária entre opções.
8. Avançar para uma nova sala.
9. Enfrentar uma ameaça de elite ou chefe.
10. Concluir a missão ou morrer.
11. Receber uma tela de resultados.
12. Atualizar a progressão permanente.
13. Preparar a próxima incursão.

A duração inicial de uma missão deve ficar entre 5 e 10 minutos, com possibilidade de ajuste após testes.

O objetivo é que o jogador consiga experimentar o ciclo inteiro sem precisar desbloquear conteúdo adicional.

---

## 4. Personagens, classes e builds

### 4.1 Regra fundamental

Cada personagem deve ter uma identidade mecânica clara. A escolha do personagem precisa mudar a maneira de jogar.

Equipamentos não serão definidos apenas por raridade ou valor numérico. Eles deverão interagir com as mecânicas da personagem e incentivar decisões de build.

### 4.2 Personagem inicial: VANGUARD

Nome provisório: Vanguard — Operador de Assalto.

Função: combate a curta e média distância, mobilidade controlada e pressão ofensiva.

Atributos iniciais sugeridos:

- Vida: 100.
- Escudo: 25.
- Velocidade de movimento: valor de referência configurável.
- Ataque básico: disparo de arma energética.
- Habilidade ativa: investida curta que causa dano e reposiciona.
- Passiva: bônus temporário de eficiência após eliminar um inimigo, sujeito a balanceamento.

Esses valores são parâmetros de protótipo, não números definitivos.

### 4.3 Classes futuras

Arquétipos candidatos:

- Bulwark: defesa, escudos e controle de espaço.
- Specter: mobilidade, precisão e ataques de oportunidade.
- Technician: drones, torretas e controle tecnológico.
- Reaper: combate próximo, risco elevado e recuperação por agressividade.

Essas classes não fazem parte do conteúdo obrigatório do MVP.

### 4.4 Restrições de equipamentos

Cada item deve declarar suas condições de utilização:

- Classes permitidas.
- Slots compatíveis.
- Requisitos de atributos, se existirem.
- Efeitos passivos e ativos.
- Modificadores de atributos.
- Raridade opcional.
- Sinergias com habilidades.

Exemplo conceitual: um módulo de sobrecarga só pode ser equipado por personagens com especialização energética. Ele aumenta o dano das habilidades, mas eleva o consumo de energia.

O sistema deverá impedir equipamentos incompatíveis, tanto na interface quanto na lógica de gameplay. Não confiar exclusivamente em esconder opções inválidas na interface.

**Teste das restrições com uma só personagem:** como o MVP tem apenas Vanguard jogável, a regra de compatibilidade deve ser testada com pelo menos uma **classe fictícia de teste**, não jogável e não exposta ao jogador, definida apenas nos dados de teste. Itens exclusivos dessa classe devem ser recusados para Vanguard e vice-versa.

---

## 5. Sistema de combate híbrido

O combate combinará ação em tempo real com decisões táticas de curta duração.

### 5.1 Componentes

- Movimento livre com resposta imediata.
- Ataque básico com mira automática assistida ou direção de mira.
- Habilidades com recarga.
- Esquiva ou deslocamento defensivo.
- Áreas de perigo claramente visíveis.
- Inimigos com padrões reconhecíveis.
- Interrupções e janelas de vulnerabilidade.
- Feedback de dano, acerto, recarga e estado.
- Pausa e menus sem bloquear indevidamente a simulação em situações não previstas.

O sistema não será baseado em turnos no MVP.

### 5.2 Regras de legibilidade

Cada ataque inimigo relevante deve possuir um aviso visual antes de causar dano.

O jogador precisa conseguir identificar:

- Quem está atacando.
- Qual região será atingida.
- Quando o ataque ocorrerá.
- Como evitar ou reduzir o dano.

A dificuldade deve resultar de padrões, pressão e escolhas, não de dano invisível ou aleatório.

### 5.3 Modelo de inimigos

**Drone de patrulha**

- Mantém distância.
- Dispara projéteis simples.
- Obriga o jogador a se movimentar.

**Caçador corpo a corpo**

- Aproxima-se do jogador.
- Anuncia um ataque.
- Executa investida ou golpe.
- Possui uma janela curta de recuperação.

**Elite de protótipo**

- Combina ataques dos inimigos anteriores.
- Possui mais vida e uma mecânica de área.
- Encerra a missão quando derrotado.

A IA deve utilizar máquinas de estado simples, sem depender de modelos externos.

### 5.4 Modelo de mira (decisão fechada)

**Mira automática assistida no toque** (o ataque mira no inimigo mais próximo ou no mais alinhado à direção do movimento) e **mira direcional com mouse** no desktop. Ambos produzem a mesma intenção de gameplay (`aim_direction`), sem duplicar a lógica de combate. Reavaliar apenas se os testes mostrarem necessidade real de mira manual. Registrada em `docs/DECISIONS.md`.

---

## 6. Progressão durante a missão e permanente

### 6.1 Progressão durante a missão

As melhorias obtidas durante a incursão são temporárias.

Exemplos:

- +15% de dano do ataque básico.
- Redução da recarga da habilidade.
- Escudo adicional após esquivar.
- Projétil extra em ataques.
- Recuperação limitada de vida ao eliminar inimigos.

A cada recompensa, apresentar três escolhas quando houver opções suficientes. As escolhas devem possuir efeitos compreensíveis e oferecer estilos diferentes.

A geração de recompensas deve usar uma fonte de aleatoriedade controlável (semente fixável) para facilitar os testes.

### 6.2 Progressão permanente

A progressão permanente deve existir desde o MVP, mas ser pequena.

O protótipo poderá oferecer:

- Registro de missões concluídas.
- Recursos de missão obtidos.
- Desbloqueio de um aprimoramento básico.
- Estatísticas de combate.
- Persistência do personagem e dos desbloqueios.

A progressão permanente não deve tornar a dificuldade irrelevante. Preferir novas opções táticas e especializações a aumentos ilimitados de atributos.

### 6.3 Morte e perda de progresso

O MVP deverá adotar a seguinte regra:

- Melhorias temporárias da missão são perdidas ao morrer.
- Estatísticas e registros permanentes são preservados.
- Recursos permanentes só são concedidos conforme regras explícitas de recompensa.
- O jogador recebe uma explicação clara do resultado.

A morte permanente de personagem não será implementada no MVP. A permanência significa que o personagem é um agente persistente entre as missões, e não uma unidade descartada automaticamente após uma derrota.

Qualquer futura mecânica de morte permanente deverá ser uma decisão de design separada, com aviso claro e testes específicos.

---

## 7. Câmera, visual e direção de arte

### 7.1 Câmera

Utilizar câmera isométrica ou pseudo-isométrica.

A apresentação pode ser construída em 3D com câmera ortográfica ou em 2D com sprites e cenário apropriados. **Decisão fechada: 2D com visual isométrico** (registrada em `docs/DECISIONS.md`).

Recomendação inicial: **2D com visual isométrico**, por ser mais barato de produzir, mais leve em dispositivos móveis e mais fácil de depurar para um desenvolvedor solo. Reavaliar apenas se houver motivo concreto.

A câmera deverá:

- Acompanhar o personagem.
- Manter o jogador visível.
- Evitar movimentos excessivos.
- Respeitar limites da arena.
- Manter a leitura dos ataques inimigos.
- Funcionar em diferentes proporções de tela.

### 7.2 Identidade visual

Direção sugerida:

- Ficção científica industrial.
- Estruturas metálicas e superfícies desgastadas.
- Luzes de energia e materiais emissivos.
- Paleta escura com cores de destaque.
- Efeitos de impacto curtos e legíveis.
- Interface minimalista, com hierarquia visual forte.
- Animações responsivas.
- Tipografia consistente.
- Partículas e pós-processamento com uso moderado.

O visual premium não deve depender de efeitos pesados. A prioridade é a qualidade percebida, a coerência e a clareza.

No MVP, usar recursos próprios simples, placeholders ou assets cuja licença permita uso no projeto. Não incorporar assets sem verificar sua licença.

---

## 8. Orientação e layout

### 8.1 Paisagem (MVP)

- Área de combate ampla.
- Movimento no canto inferior esquerdo; ataque principal e habilidades no canto inferior direito.
- Vida e recursos na parte superior esquerda.
- Objetivos e indicadores na parte superior direita.
- Elementos importantes afastados das bordas físicas.

O projeto deve bloquear a orientação em paisagem nas configurações de exportação do MVP.

### 8.2 Retrato (pós-MVP)

Não faz parte do MVP. Quando for implementado:

- Movimento no quadrante inferior esquerdo.
- Ataque principal e habilidades no quadrante inferior direito.
- Vida e recursos na parte superior.
- Objetivos em área compacta.
- Câmera ajustada para reduzir a área horizontal.

### 8.3 Regras de implementação (valem desde o MVP)

Criar um único sistema de gameplay, sem duplicar a lógica por orientação.

A interface deve ser construída com containers, âncoras e layouts responsivos, para que o retrato possa ser adicionado depois sem reescrever a HUD.

Não presumir que a resolução será sempre igual à de um iPhone específico.

Implementar zonas seguras para recortes de tela e áreas ocupadas pelo sistema operacional.

---

## 9. Estratégia técnica e ambiente de desenvolvimento

### 9.1 Ferramentas

- Windows 10 ou 11.
- Godot 4.x estável.
- GDScript.
- Claude Code no terminal do Windows.
- Git para versionamento e conta no GitHub (repositório remoto que dispara o CI).
- VS Code ou outro editor opcional.
- Terminal PowerShell.
- iPhone físico.
- AltStore ou Sideloadly para instalar a build no iPhone (seção 14).
- Serviço de CI com runner macOS gratuito (seção 14).

Fixar a versão da engine no início e documentá-la no repositório. Não atualizar a versão da Godot durante uma etapa sem verificar a compatibilidade do projeto.

### 9.2 Por que GDScript

GDScript reduz a complexidade inicial, integra-se diretamente à Godot e evita acrescentar uma camada de ferramentas desnecessária.

Não utilizar C# no MVP. A documentação da Godot indica que projetos C# em Godot 4 não podem ser exportados para iOS nas versões consultadas; o foco é acelerar o protótipo e reduzir o risco técnico da exportação móvel.

### 9.3 Renderer

O renderer (Compatibility ou Mobile) deve ser escolhido na **Etapa 0B**, com base no teste real em iPhone, e registrado em `docs/DECISIONS.md`. Não trocar de renderer depois do início da Etapa 1 sem reavaliar o impacto.

### 9.4 NixOS e Linux virtualizado

NixOS não é necessário para o desenvolvimento principal.

A recomendação é desenvolver diretamente no Windows e usar o Linux virtualizado apenas se houver uma necessidade concreta, por exemplo:

- Testar scripts de automação.
- Verificar compatibilidade com Linux.
- Reproduzir um ambiente de CI.
- Executar ferramentas auxiliares.

O Linux virtualizado não substitui o macOS para iOS. Não manter duas cópias independentes do projeto. Se o Linux virtualizado for usado, compartilhar o repositório via Git e evitar editar simultaneamente os mesmos arquivos em dois ambientes.

### 9.5 Regras de dependências

- Não adicionar plugins sem uma necessidade documentada.
- Preferir funcionalidades nativas da Godot.
- Manter as dependências explícitas.
- Registrar versões de ferramentas e plugins.
- Evitar serviços externos no jogo no MVP.
- Não guardar segredos, senhas ou credenciais no repositório.

---

## 10. Arquitetura do projeto Godot

### 10.1 Princípios

1. Separar regras de gameplay da interface.
2. Separar dados de conteúdo da lógica de execução.
3. Usar cenas e scripts pequenos, com responsabilidades claras.
4. Evitar um script global que concentre todo o jogo.
5. Centralizar regras de dano, atributos e compatibilidade de itens.
6. Utilizar sinais para comunicação entre sistemas quando apropriado.
7. Criar sistemas simples antes de abstrações genéricas.
8. Evitar overengineering para recursos que ainda não existem.

### 10.2 Árvore de diretórios proposta

```
project_root/
├── project.godot
├── README.md
├── CHANGELOG.md
├── CLAUDE.md
├── codemagic.yaml               (criado na Etapa 0B)
├── docs/
│   ├── REQUIREMENTS.md
│   ├── DECISIONS.md
│   ├── IOS_PIPELINE.md          (criado na Etapa 0B)
│   └── TEST_PLAN.md
├── scenes/
│   ├── boot/
│   │   └── boot.tscn
│   ├── menus/
│   │   ├── main_menu.tscn
│   │   ├── character_select.tscn
│   │   └── results_screen.tscn
│   ├── gameplay/
│   │   ├── run.tscn
│   │   ├── arena.tscn
│   │   ├── room.tscn
│   │   └── extraction_zone.tscn
│   ├── actors/
│   │   ├── player/
│   │   │   └── player.tscn
│   │   └── enemies/
│   │       ├── patrol_drone.tscn
│   │       ├── melee_hunter.tscn
│   │       └── elite_enemy.tscn
│   ├── combat/
│   │   ├── projectile.tscn
│   │   └── damage_number.tscn
│   └── ui/
│       ├── hud.tscn
│       ├── ability_button.tscn
│       ├── reward_choice.tscn
│       └── pause_menu.tscn
├── scripts/
│   ├── core/
│   │   ├── run_manager.gd
│   │   ├── save_manager.gd
│   │   └── settings_manager.gd
│   ├── actors/
│   │   ├── player_controller.gd
│   │   └── enemy_controller.gd
│   ├── combat/
│   │   ├── health_component.gd
│   │   ├── damage_service.gd
│   │   └── projectile.gd
│   ├── progression/
│   │   ├── reward_service.gd
│   │   └── meta_progression.gd
│   ├── inventory/
│   │   ├── equipment_service.gd
│   │   └── equipment_rules.gd
│   └── ui/
│       ├── hud_controller.gd
│       └── responsive_layout.gd
├── resources/
│   ├── characters/
│   ├── enemies/
│   ├── items/
│   ├── abilities/
│   └── upgrades/
├── assets/
│   ├── art/
│   ├── audio/
│   ├── fonts/
│   └── vfx/
└── tests/
    ├── test_combat.md
    ├── test_progression.md
    └── test_ui.md
```

Esta árvore é uma referência inicial. O Claude Code não deve criar todos esses arquivos vazios de uma vez. Cada diretório e script deve surgir quando uma etapa precisar dele.

### 10.3 Autoloads

Começar com o mínimo necessário:

- RunManager: estado da incursão atual.
- SaveManager: leitura e gravação do progresso local.
- SettingsManager: preferências do jogador.

Não criar autoload para cada sistema. Sistemas de combate, itens e inimigos devem continuar locais ou ser instanciados conforme necessário.

### 10.4 Dados e recursos

Utilizar recursos personalizados da Godot ou estruturas de dados tipadas para definir:

- Personagens.
- Armas e equipamentos.
- Habilidades.
- Melhorias temporárias.
- Inimigos.
- Configuração de salas.

Exemplo conceitual de dados de equipamento:

```gdscript
class_name EquipmentData
extends Resource

@export var item_id: StringName
@export var display_name: String
@export var allowed_classes: Array[StringName] = []
@export var slot: StringName
@export var damage_bonus: float = 0.0
@export var cooldown_multiplier: float = 1.0
```

O Claude Code deve validar os nomes e tipos disponíveis na versão fixada da Godot e ajustar o exemplo caso necessário.

A compatibilidade deve ser verificada em uma função central, com testes para itens permitidos e proibidos.

---

## 11. Interface e entrada

### 11.1 Controles de desktop

- WASD ou setas: movimento.
- Mouse: direção de mira (seção 5.4).
- Botão esquerdo: ataque principal.
- Espaço: esquiva.
- Q: habilidade especial.
- Escape: pausa.

Os controles deverão ser configuráveis pela Input Map da Godot.

### 11.2 Controles de iPhone

- Joystick virtual para movimento.
- Botão de ataque.
- Botão de habilidade.
- Botão de esquiva.
- Feedback visual de recarga.
- Alvos de toque grandes o suficiente para uso confortável.
- Opção de reposicionar elementos essenciais no futuro.

A lógica de combate não deve depender diretamente de eventos do mouse ou do toque. Utilizar uma camada de entrada que converta essas ações em intenções de gameplay.

Exemplo conceitual: `move_direction`, `aim_direction`, `attack_pressed`, `ability_pressed`, `dodge_pressed`.

### 11.3 Pausa

A pausa deverá:

- Interromper os sistemas de gameplay relevantes.
- Exibir opções de continuar, reiniciar e sair da missão.
- Evitar que inimigos continuem atacando durante a pausa.
- Preservar o estado da missão ao voltar.

---

## 12. Salvamento e persistência

O MVP deverá salvar localmente:

- Versão do formato de salvamento.
- Melhorias permanentes desbloqueadas.
- Estatísticas básicas.
- Configurações.
- Missões concluídas.

O arquivo deverá ser salvo em um diretório apropriado por meio das APIs da Godot, como `user://`.

### 12.1 Requisitos de segurança e robustez

- Não usar caminhos absolutos específicos do Windows.
- Validar dados ao carregar.
- Tratar arquivo inexistente.
- Tratar dados inválidos ou corrompidos sem travar o jogo.
- Criar uma estratégia simples de backup ou recuperação.
- Evitar salvar a cada quadro.
- Versionar o formato para permitir migrações futuras.

Não desenvolver proteção sofisticada contra adulteração de salvamento no MVP.

**Nota sobre sideload:** com assinatura gratuita, o app é reinstalado a cada 7 dias. Reinstalar por cima, mantendo o mesmo Bundle Identifier, deve preservar os dados do app, mas isso precisa ser verificado na Etapa 0B. Até lá, não confiar que o salvamento no iPhone sobrevive a uma reinstalação.

---

## 13. Qualidade visual

### 13.1 MVP: presets manuais

O MVP oferece três presets escolhidos pelo jogador: **Baixa, Média e Alta**.

Cada preset deve alterar comportamentos reais e verificáveis, por exemplo:

- Escala de resolução de renderização, quando suportada.
- Densidade e limite de partículas simultâneas.
- Quantidade de efeitos visuais opcionais.
- Sombras, se utilizadas.

Não criar opções que apareçam no menu sem alterar o comportamento do jogo. Cada controle exposto deve ter efeito mensurável.

### 13.2 Pós-MVP

Ficam para depois do vertical slice, e somente com medições em dispositivos reais:

- Preset automático baseado em medição de desempenho.
- Perfil adaptativo com qualidade mínima e máxima.
- Preset Ultra.

O sistema não deve prometer que qualquer dispositivo executará todas as configurações no máximo.

---

## 14. Estratégia para iOS sem Mac e sem custo

### 14.1 Fatos que determinam o plano

- A documentação da Godot exige que a exportação para iOS seja feita em um computador macOS com Xcode instalado. Não é possível exportar o iOS direto do Windows.
- Portanto, **toda exportação e compilação iOS acontecerá em um runner macOS na nuvem (CI)**, que roda a Godot e o Xcode. O Windows continua sendo o ambiente de desenvolvimento.
- O resultado do CI é um `.ipa` não assinado, que o AltStore ou o Sideloadly assinam com o Apple ID gratuito na hora da instalação.

Valores conferidos em outubro de 2026. Os planos mudam; revalidar antes de depender deles.

### 14.2 Opções de CI gratuitas

| Opção | Custo | Limite | Observação |
|---|---|---|---|
| **GitHub Actions, repositório público** | Gratuito | Runners padrão gratuitos em repositórios públicos | O código do jogo ficará público. Assets sem licença de redistribuição não devem ir para o repositório. |
| **Codemagic, conta pessoal** | Gratuito | 500 minutos por mês em macOS M2, 1 build por vez | Aceita repositório privado, mas precisa de acesso de leitura ao repositório. Conta de equipe não tem os minutos gratuitos. |
| **GitHub Actions, repositório privado** | Gratuito | Plano Free tem 2.000 minutos, e minutos de macOS contam 10x, resultando em cerca de 200 minutos de macOS por mês | Serve para poucos builds. |

**Decisão fechada: Codemagic com repositório privado**, configurado em `codemagic.yaml`. GitHub Actions com repositório público fica como alternativa de reserva, registrada em `docs/DECISIONS.md`.

### 14.3 Fluxo de build (a ser validado na Etapa 0B)

1. O desenvolvedor envia o código ao repositório remoto.
2. O CI inicia um runner macOS.
3. O workflow instala a versão fixada da Godot (binário para macOS) e os export templates da mesma versão.
4. A Godot, em modo headless, exporta o preset iOS para uma pasta contendo um projeto Xcode.
5. O `xcodebuild` compila para dispositivo com a assinatura de código desativada.
6. O workflow empacota o `.app` resultante em uma pasta `Payload`, compacta como `.ipa` e publica como artefato.
7. O desenvolvedor baixa o `.ipa` no Windows e instala no iPhone com AltStore ou Sideloadly.

Este é o fluxo conhecido para builds sem assinatura, mas **não deve ser dado como funcional antes de ser executado**. Pontos que o Claude Code deve verificar na documentação da versão fixada:

- Quais campos do preset de exportação iOS são obrigatórios (Bundle Identifier, Team ID, entre outros) e quais valores aceitam quando não há conta paga.
- Como a assinatura é desativada no `xcodebuild` para essa versão da Godot e do Xcode.
- Qual versão do Xcode e do macOS o runner oferece.

### 14.4 Instalação no iPhone com conta gratuita

- Ferramentas: AltStore ou Sideloadly, usando um Apple ID gratuito.
- No Windows, o AltStore exige iTunes e iCloud instalados a partir do site da Apple, não da Microsoft Store.
- No iPhone, ativar o Modo Desenvolvedor (Ajustes > Privacidade e Segurança).
- O app expira a cada 7 dias e precisa ser renovado. O AltStore renova automaticamente quando o AltServer está rodando no PC e o iPhone está na mesma rede.
- Limite de 3 apps ativos assinados com a conta gratuita.
- Recursos como Game Center, notificações push e compras no app não funcionam com assinatura gratuita.
- Considerar um Apple ID secundário só para sideload, em vez do principal.
- Nunca colocar credenciais do Apple ID no repositório, no workflow ou em qualquer arquivo do projeto. Como o `.ipa` é gerado sem assinatura, o CI não precisa de nenhum segredo da Apple.

### 14.5 Limitações e riscos

- **Sem Xcode local:** não há depuração em dispositivo nem acesso fácil a logs do iPhone. O jogo deve ter um log simples gravado em `user://` e, se necessário, uma sobreposição de depuração opcional na tela.
- **Ciclo de iteração lento e com custo em minutos:** cada build iOS consome minutos de CI. Desenvolver e testar quase tudo no Windows e gerar builds iOS apenas em marcos (final de etapa).
- **Os testes no Windows não substituem testes no iPhone** (toque, desempenho, memória, áudio).
- **Sem TestFlight e sem distribuição pública** com assinatura gratuita. Ver 14.6.
- Os limites e preços dos serviços de CI podem mudar.

### 14.6 Quando pagar a conta Apple Developer

A conta paga (Apple Developer Program) só é necessária para:

- Distribuir para outras pessoas (TestFlight).
- Publicar na App Store.
- Usar recursos que dependem de assinatura paga.
- Evitar a renovação semanal.

Até o vertical slice estar validado, o plano é **não pagar nada**. A compra da conta é uma decisão da fase de distribuição (Etapa 10) e não bloqueia o desenvolvimento.

### 14.7 Política de arquitetura

Evitar plugins nativos de iOS no MVP. Se algum plugin for indispensável, documentar sua dependência de Xcode, suas instruções de instalação e o impacto no pipeline de CI.

Não incorporar funcionalidades específicas do iOS até que haja uma necessidade clara.

---

## 15. Plano de execução por etapas

Cada etapa deverá ser concluída e validada antes de iniciar a próxima.

### Etapa 0A — Preparação do ambiente

**Objetivo:** criar uma base reproduzível.

**Tarefas:**

- Instalar Godot 4.x estável e registrar a versão.
- Instalar Git.
- Instalar Claude Code e autenticar conforme o método suportado.
- Criar repositório Git local e repositório remoto (GitHub).
- Criar projeto Godot.
- Criar README e documentos em `docs/` (REQUIREMENTS, DECISIONS).
- Configurar `.gitignore` para Godot.
- Executar um projeto vazio.

**Critérios de aceitação:**

- O projeto abre sem erros.
- O jogo vazio executa no Windows.
- Git registra o estado inicial.
- O Claude Code consegue ler e modificar arquivos do projeto.
- Não há segredos ou credenciais no repositório.

### Etapa 0B — Prova do fluxo iOS

**Objetivo:** provar que o caminho Windows, CI, `.ipa` e iPhone funciona antes de escrever o jogo. É o maior risco técnico do projeto.

**Tarefas:**

- Criar uma cena mínima: texto na tela, um botão que incrementa um contador e escrita de um valor simples em `user://`.
- Configurar o preset de exportação iOS e bloquear paisagem.
- Conectar o repositório privado ao Codemagic (serviço já decidido, ver 14.2).
- Criar o `codemagic.yaml` conforme 14.3.
- Gerar o `.ipa` não assinado como artefato.
- Instalar no iPhone por AltStore ou Sideloadly.
- Testar os dois renderers e registrar a escolha.
- Verificar se o valor gravado em `user://` sobrevive ao fechamento do app e a uma reinstalação.
- Documentar o procedimento em `docs/IOS_PIPELINE.md`, incluindo tempo de build e minutos consumidos.

**Critérios de aceitação:**

- O workflow gera um `.ipa` sem intervenção manual além do envio do código.
- O app abre no iPhone, responde ao toque e roda em paisagem.
- O renderer escolhido está registrado e funciona no aparelho.
- O comportamento do salvamento em `user://` está documentado.
- Procedimento documentado de ponta a ponta, sem credenciais no repositório.

**Se esta etapa falhar:** registrar o bloqueio, avaliar outra opção de CI e, se nenhuma funcionar, o desenvolvimento continua no Windows com Android como primeira plataforma móvel, e a decisão sobre iOS é revista (por exemplo, acesso temporário a um Mac).

### Etapa 1 — Protótipo de movimento

**Pré-requisitos:** Etapa 0B concluída (ou bloqueio registrado).

**Objetivo:** controlar um personagem em uma arena vazia.

**Tarefas:**

- Criar cena da arena.
- Criar personagem controlável.
- Implementar movimentação.
- Adicionar câmera.
- Criar colisões básicas.
- Adicionar Input Map.
- Validar diferentes proporções de tela.

**Critérios de aceitação:**

- Movimento previsível.
- Colisões funcionais.
- Câmera não perde o personagem.
- Não há erros de execução.
- O protótipo pode ser reiniciado sem reiniciar o editor.

### Etapa 2 — Combate básico

**Pré-requisitos:** Etapa 1 concluída. Modelo de mira já fechado (seção 5.4).

**Objetivo:** implementar o ciclo de ataque e dano.

**Tarefas:**

- Criar componente de vida.
- Criar serviço de dano.
- Implementar ataque básico.
- Implementar projétil ou ataque equivalente.
- Criar inimigo simples.
- Implementar derrota e remoção de inimigos.
- Adicionar feedback visual de dano.

**Critérios de aceitação:**

- Ataques causam dano uma única vez por evento esperado.
- Vida nunca fica abaixo de zero.
- Inimigos podem ser derrotados.
- O jogador pode sofrer dano.
- O estado de derrota funciona sem travar o jogo.

### Etapa 3 — Habilidade e esquiva

**Objetivo:** introduzir decisões de combate.

**Tarefas:**

- Implementar habilidade especial.
- Implementar recarga.
- Implementar esquiva.
- Criar avisos visuais de ataques inimigos.
- Adicionar indicadores de recarga.

**Critérios de aceitação:**

- A habilidade não pode ser utilizada durante sua recarga.
- A esquiva respeita suas regras de duração e disponibilidade.
- O jogador consegue reconhecer ataques anunciados.
- Os controles respondem imediatamente.

### Etapa 4 — Primeiro encontro completo

**Objetivo:** montar um combate que tenha começo e fim.

**Tarefas:**

- Criar dois tipos de inimigos.
- Criar ondas ou grupos de combate.
- Implementar condições de vitória.
- Implementar condição de derrota.
- Adicionar transição de resultado.
- Ajustar vida, dano e duração.

**Critérios de aceitação:**

- É possível concluir ou perder um encontro.
- O encontro não fica preso aguardando inimigos inexistentes.
- O estado de combate é limpo corretamente ao reiniciar.

### Etapa 5 — Recompensas e builds

**Objetivo:** validar a identidade roguelike.

**Tarefas:**

- Criar dados de melhorias.
- Implementar seleção de recompensa.
- Aplicar melhorias temporárias.
- Criar dados de equipamentos.
- Implementar slots e restrições de classe.
- Criar a classe fictícia de teste (seção 4.4) apenas nos dados de teste.
- Exibir equipamentos compatíveis.
- Validar efeitos de itens em combate.

**Critérios de aceitação:**

- Melhorias alteram efetivamente o gameplay.
- Itens incompatíveis com a classe são recusados pela lógica, comprovado por teste com a classe fictícia.
- A seleção não duplica recompensas ou efeitos.
- As escolhas são legíveis e permitem decisões diferentes.

### Etapa 6 — Missão vertical slice

**Objetivo:** conectar os sistemas em uma experiência completa.

**Tarefas:**

- Criar menu inicial simples.
- Criar seleção da personagem inicial.
- Conectar sala inicial, recompensa e encontro final.
- Implementar resultado de missão.
- Implementar reinício.
- Adicionar áudio e efeitos essenciais.
- Garantir que a missão possa ser jogada do começo ao fim.

**Critérios de aceitação:**

- Uma missão pode ser concluída em aproximadamente 5–10 minutos.
- Vitória e derrota são reproduzíveis.
- Nenhuma etapa exige intervenção no editor.
- Reiniciar não preserva indevidamente melhorias temporárias.
- O jogo continua executável após diversas partidas.

### Etapa 7 — Salvamento permanente

**Objetivo:** preservar progresso entre sessões.

**Tarefas:**

- Criar sistema de salvamento.
- Persistir registros e desbloqueios.
- Implementar tratamento de arquivo inválido.
- Criar versão do formato de dados.
- Testar fechamento e reabertura.

**Critérios de aceitação:**

- O progresso válido sobrevive ao fechamento.
- Arquivo ausente cria um estado inicial válido.
- Dados inválidos não provocam falha fatal.
- Melhorias temporárias não são salvas como permanentes.

### Etapa 8 — Interface adaptável, toque e qualidade

**Objetivo:** preparar a experiência para dispositivos móveis em paisagem.

**Tarefas:**

- Criar HUD responsiva (containers e âncoras).
- Implementar o layout de paisagem.
- Criar controles por toque.
- Adicionar zonas seguras.
- Implementar os três presets de qualidade com efeitos reais.
- Validar escalas de interface em proporções diferentes.

**Critérios de aceitação:**

- A interface não apresenta sobreposição crítica em paisagem.
- Botões permanecem utilizáveis.
- Cada preset de qualidade produz alteração verificável.
- O jogo permanece legível em telas menores.

### Etapa 9 — Otimização e validação no iPhone

**Objetivo:** reduzir os riscos técnicos da plataforma final.

**Tarefas:**

- Medir uso de CPU e GPU no Windows.
- Reduzir processamento desnecessário.
- Limitar efeitos simultâneos.
- Revisar memória e ciclo de vida das cenas.
- Revisar permissões e plugins.
- Gerar builds iOS pelo CI e testar no iPhone real.
- Medir desempenho e estabilidade no aparelho.
- Atualizar `docs/IOS_PIPELINE.md`.

**Critérios de aceitação:**

- A build iOS do vertical slice é gerada pelo CI e instalada no iPhone.
- Controles de toque funcionam no dispositivo.
- A aplicação mantém estabilidade nas sessões de teste.
- O desempenho atende às metas definidas para os dispositivos escolhidos, com medições registradas.
- O procedimento de renovação semanal está documentado.

### Etapa 10 — Distribuição de teste (requer decisão de pagamento)

**Objetivo:** disponibilizar uma versão para avaliação externa.

Esta etapa só começa após decisão explícita de adquirir a conta Apple Developer (14.6).

**Tarefas:**

- Configurar assinatura e identificadores.
- Adaptar o CI para build assinada.
- Preparar build de teste.
- Distribuir pelo TestFlight quando elegível.
- Corrigir falhas críticas.
- Preparar informações da loja.
- Revisar requisitos atuais da App Store.

**Critérios de aceitação:**

- Build assinada e instalável.
- Testes concluídos no dispositivo-alvo.
- Nenhuma falha crítica conhecida.
- Recursos, privacidade e metadados documentados.
- Aprovação da revisão da Apple antes de prometer publicação pública.

---

## 16. Testes e qualidade

### 16.1 Testes funcionais obrigatórios

- Movimento nas quatro direções.
- Colisões com obstáculos.
- Ataque contra inimigos.
- Recebimento de dano.
- Morte do jogador.
- Morte de inimigos.
- Uso e recarga de habilidades.
- Esquiva.
- Seleção de recompensas.
- Restrição de equipamentos (incluindo a classe fictícia).
- Vitória e derrota.
- Reinício de missão.
- Salvamento e carregamento.
- Pausa e retorno.
- Troca de preset de qualidade.
- Instalação e execução da build iOS no iPhone (a cada marco).

### 16.2 Testes automatizados

As regras puras (dano, compatibilidade de equipamentos, sorteio de recompensas com semente fixa, serialização do salvamento) devem ter testes automatizados quando existirem. Avaliar o plugin GUT na Etapa 2; só adotar se a dependência for registrada em `docs/DECISIONS.md`. Enquanto isso, os procedimentos manuais em `tests/` valem como registro.

### 16.3 Testes de regressão

Depois de cada etapa, verificar:

- O jogo continua abrindo.
- A missão anterior continua jogável.
- Não surgiram erros de parser.
- Não há referências quebradas a cenas ou recursos.
- O salvamento continua compatível.
- Os sistemas anteriores continuam funcionando.
- O workflow de CI continua gerando o `.ipa`.

### 16.4 Metas iniciais de desempenho

Definir como meta de projeto, sujeita a medição:

- 60 FPS como objetivo em dispositivos compatíveis.
- Controles responsivos.
- Ausência de travamentos prolongados.
- Carregamento razoável de cenas.
- Consumo de memória estável em sessões repetidas.

Não afirmar que essas metas foram atingidas sem medir em hardware real.

---

## 17. Regras de trabalho com Claude Code

O Claude Code deverá atuar como assistente de implementação incremental.

### 17.1 Regras obrigatórias

1. Ler os requisitos antes de modificar arquivos.
2. Verificar a estrutura existente antes de criar novas cenas.
3. Trabalhar somente na etapa autorizada.
4. Não reescrever todo o projeto para corrigir um problema pequeno.
5. Não introduzir dependências sem justificativa.
6. Não inventar APIs da Godot nem opções de CI; confirmar na documentação da versão fixada.
7. Preferir scripts pequenos e tipados.
8. Não criar arquivos vazios sem função.
9. Executar verificações disponíveis após alterações.
10. Informar limitações de testes que não puderam ser executados.
11. Manter documentação atualizada quando a arquitetura mudar.
12. Não declarar uma tarefa concluída sem verificar seus critérios de aceitação.
13. Não remover dados do usuário, configurações ou arquivos sem autorização.
14. Não modificar configurações globais do sistema operacional sem autorização explícita.
15. Não acessar, solicitar ou transmitir credenciais (Apple ID, tokens, senhas). O fluxo de CI desta fase não precisa de nenhuma.
16. Não afirmar que o fluxo iOS funciona sem que o `.ipa` tenha sido gerado e executado no iPhone.

### 17.2 Fluxo recomendado por tarefa

1. Analisar o estado atual do projeto.
2. Explicar brevemente a implementação proposta.
3. Alterar apenas os arquivos necessários.
4. Executar o jogo ou verificações automatizadas disponíveis.
5. Corrigir erros introduzidos pela mudança.
6. Resumir arquivos modificados.
7. Informar testes executados e resultados.
8. Listar limitações e próximo passo recomendado.

### 17.3 Versionamento

Criar um commit ao final de cada etapa e em marcos funcionais, por exemplo:

- `chore: initialize Godot project`
- `ci: add unsigned iOS build workflow`
- `feat: implement player movement`
- `feat: add basic combat`
- `feat: add temporary upgrades`
- `feat: add mission progression`
- `feat: persist meta progression`
- `feat: add responsive mobile controls`

O Claude Code **não deve executar `git push`, disparar workflows ou publicar builds sem autorização explícita do usuário** naquela ocasião. Como o build iOS depende do envio do código ao remoto, o usuário fará o push (ou o autorizará) quando quiser gerar uma build, lembrando que cada build consome minutos de CI.

---

## 18. Prompts para Claude Code

### Prompt 1 — Preparação e análise

```
Leia CLAUDE.md, docs/REQUIREMENTS.md e docs/DECISIONS.md.
Estamos criando um roguelike sci-fi isométrico em Godot 4.x com GDScript.
O ambiente principal é Windows. O destino é iOS, mas não temos Mac:
as builds iOS sairão de um CI com runner macOS gratuito e serão
instaladas no iPhone por sideload (AltStore ou Sideloadly).
Nesta tarefa, apenas inspecione o ambiente e o repositório.
1. Verifique se o projeto Godot existe.
2. Identifique a versão da engine, se disponível.
3. Inspecione a estrutura atual.
4. Liste os pré-requisitos ausentes.
5. Proponha a estrutura mínima para a Etapa 0A.
6. Não implemente sistemas de gameplay ainda.
7. Não instale ferramentas, não altere configurações globais e não apague arquivos.
Apresente o diagnóstico e os próximos passos.
```

### Prompt 2 — Criar a base do projeto (Etapa 0A)

```
Implemente apenas a Etapa 0A de docs/REQUIREMENTS.md.
Crie ou organize a estrutura mínima do projeto Godot para o roguelike.
Adicione uma cena inicial funcional, README, .gitignore para Godot e
documentação básica (incluindo docs/DECISIONS.md).
Não implemente combate, inventário, progressão ou IA nesta etapa.
Use GDScript e recursos nativos da Godot. Evite dependências externas.
Não crie arquivos vazios apenas para preencher a árvore planejada.
Não faça push. Execute as verificações disponíveis e informe exatamente
o que foi validado. Se não conseguir executar o projeto, explique a
limitação sem declarar sucesso.
```

### Prompt 2B — Prova do fluxo iOS (Etapa 0B)

```
Implemente apenas a Etapa 0B de docs/REQUIREMENTS.md.
Objetivo: provar o caminho Windows -> CI macOS -> .ipa sem assinatura ->
sideload no iPhone, usando um projeto mínimo (texto, botão com contador e
gravação de um valor em user://).
1. Consulte a documentação da Godot na versão fixada sobre exportação iOS
   e liste os campos obrigatórios do preset e como desativar a assinatura
   no xcodebuild. Não invente opções.
2. Configure o preset de exportação iOS (paisagem bloqueada).
3. Crie o codemagic.yaml na raiz (Codemagic, conforme docs/DECISIONS.md)
   que instale a
   Godot fixada e os export templates, exporte o projeto Xcode, compile sem
   assinatura, gere o .ipa e o publique como artefato.
4. Não use nem peça credenciais da Apple. Não coloque segredos no repositório.
5. Documente o procedimento em docs/IOS_PIPELINE.md, incluindo como instalar
   o .ipa com AltStore/Sideloadly e as limitações da conta gratuita.
Não faça push nem dispare o build; diga ao usuário o que fazer para
rodar. Não declare sucesso até o usuário confirmar que o app abriu no iPhone.
```

### Prompt 3 — Movimento do personagem

```
Implemente apenas a Etapa 1: protótipo de movimento.
Leia os requisitos e inspecione os arquivos existentes antes de alterá-los.
Crie uma arena de teste, um personagem controlável, câmera e colisões.
O movimento deve funcionar no Windows e não depender de entrada específica
de mouse para a lógica de gameplay.
Mantenha a arquitetura simples. Não implemente combate, IA ou progressão.
Critérios:
- movimento previsível;
- colisões funcionais;
- câmera acompanha o jogador;
- reinício funcional;
- ausência de erros de execução conhecidos.
Execute os testes possíveis e liste os arquivos modificados.
```

### Prompt 4 — Combate

```
Implemente a Etapa 2 e, somente depois de validar seus critérios, proponha
a Etapa 3.
Use o modelo de mira registrado em docs/DECISIONS.md.
Adicione vida, dano, ataque básico, projétil quando apropriado, um inimigo
simples e feedback visual.
Centralize as regras de dano. Evite duplicar lógica em personagens e inimigos.
Não implemente inventário, multiplayer ou sistemas de conteúdo avançados.
Teste dano, derrota do inimigo, dano recebido pelo jogador e reinício.
Informe resultados reais e limitações dos testes.
```

### Prompt 5 — Recompensas e builds

```
Implemente o sistema mínimo de recompensas roguelike.
As melhorias da missão são temporárias e devem desaparecer ao terminar
ou perder a incursão. A progressão permanente será tratada separadamente.
Implemente dados de equipamentos, slots e restrições de classe.
Toda incompatibilidade deve ser validada na lógica, não apenas na interface.
Crie uma classe fictícia de teste (não jogável, apenas nos dados de teste)
para comprovar que itens incompatíveis são recusados.
Crie poucas melhorias com efeitos reais e fáceis de testar.
Não crie centenas de itens, árvores extensas ou sistemas de raridade complexos.
Adicione testes ou procedimentos verificáveis para as regras implementadas.
```

### Prompt 6 — Vertical slice

```
Conecte os sistemas existentes para produzir uma missão completa.
A experiência deve incluir:
- início;
- combate;
- recompensa;
- segundo encontro;
- inimigo de elite;
- vitória ou derrota;
- resultado e reinício.
O conteúdo deve ser pequeno, mas funcional e coerente.
Não introduza multiplayer, monetização ou serviços externos.
Priorize estabilidade, legibilidade e sensação de controle.
Verifique o fluxo inteiro e corrija problemas de estado entre reinícios.
Documente os critérios ainda não satisfeitos.
```

### Prompt 7 — Interface responsiva e toque (Etapa 8)

```
Prepare a interface e os controles para as builds de iOS em paisagem.
Construa a HUD com containers e âncoras para que o retrato possa ser
adicionado depois sem reescrever o gameplay.
Implemente controles por toque, áreas seguras e três presets de qualidade
(Baixa, Média, Alta) com efeitos reais e verificáveis.
Mantenha os controles de desktop funcionais.
Revise o projeto para evitar dependências desnecessárias de Windows.
Não afirme que a build iOS funciona sem que o .ipa tenha sido gerado pelo
CI e executado no iPhone. Se ainda não foi, documente o que falta validar.
```

### Prompt 8 — Revisão de qualidade

```
Faça uma revisão técnica do vertical slice.
Procure:
- erros de execução;
- referências quebradas;
- lógica duplicada;
- salvamento incorreto;
- estados inválidos;
- controles inconsistentes;
- problemas de layout;
- processamento desnecessário;
- recursos que não são liberados;
- opções de qualidade que não produzem efeito;
- sistemas que parecem implementados, mas não produzem efeito.
Não faça uma reescrita geral. Corrija apenas problemas comprovados,
preservando o escopo e a arquitetura existentes.
Apresente uma lista de problemas encontrados, correções, testes executados
e riscos que ainda precisam de validação manual.
```

---

## 19. Definição de pronto do vertical slice

O vertical slice estará pronto quando:

- O jogador conseguir iniciar uma missão sem intervenção no editor.
- O personagem se mover e combater.
- Os inimigos apresentarem comportamentos distintos.
- Uma habilidade especial e uma esquiva funcionarem.
- O jogador receber melhorias temporárias.
- Equipamentos respeitarem as restrições da personagem.
- A missão puder terminar em vitória ou derrota.
- O resultado for exibido corretamente.
- A progressão permanente básica sobreviver ao fechamento do jogo.
- O jogo puder ser reiniciado várias vezes sem corrupção de estado.
- A interface funcionar em paisagem no Windows e no iPhone.
- Os controles de desktop e toque estiverem separados da lógica de combate.
- Os três presets de qualidade alterarem o comportamento do jogo.
- A build iOS for gerada pelo CI e executar no iPhone por sideload.
- Os testes documentados tiverem resultados verificáveis.
- Não houver erros críticos conhecidos impedindo a experiência completa.

A conclusão do vertical slice não significa que o jogo está pronto para a App Store.

---

## 20. Decisões em aberto

### Fechadas (ver `docs/DECISIONS.md`)

- Serviço de CI: Codemagic, repositório privado.
- 2D com visual isométrico.
- Mira automática assistida no toque; mouse no desktop.

### Com prazo definido

| Decisão | Prazo | Recomendação inicial |
|---|---|---|
| Renderer (Compatibility ou Mobile) | Etapa 0B | Decidir pelo teste no iPhone |

### Podem permanecer abertas durante o protótipo

- Nome comercial definitivo.
- Quantidade final de personagens.
- Modelo definitivo de morte e penalidades.
- Profundidade da progressão permanente.
- Quantidade de salas por missão.
- Dispositivos mínimos suportados.
- Metas finais de FPS.
- Retrato: quando e como entra.
- Qualidade automática ou adaptativa.
- Momento de adquirir a conta Apple Developer.
- Modelo futuro de monetização.
- Multiplayer, caso seja considerado após o lançamento.

Não bloquear o desenvolvimento do vertical slice por causa dessas decisões, desde que não afetem a arquitetura essencial.

---

## 21. Próxima ação recomendada

Começar pela **Etapa 0A** e, logo em seguida, pela **Etapa 0B**: provar que um projeto mínimo chega ao iPhone pelo fluxo gratuito antes de escrever qualquer sistema de jogo.

Em seguida, construir uma arena vazia com um personagem controlável. O primeiro objetivo de gameplay não é criar menus bonitos, dezenas de armas ou uma história extensa. É provar que a movimentação, a câmera e o combate são divertidos.

Somente depois disso devem ser adicionados progressão, equipamentos, interface premium e a adaptação final para dispositivos móveis.

**Regra de escopo:** nenhuma nova funcionalidade importante entra no MVP sem uma justificativa e sem avaliar seu impacto sobre a conclusão do vertical slice.
