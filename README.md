# Desafio: Sistema de Gestão de Pedidos e Entregas (Delivery Hub)

Neste desafio, desenvolva um aplicativo Flutter para gerenciar pedidos de um serviço de entregas, integrando-o a uma API REST mockada. O foco está no consumo assíncrono de múltiplos endpoints, manipulação correta dos verbos HTTP (GET, POST, PUT e DELETE), relacionamento entre entidades, serialização/desserialização de JSON e tratamento de estados de interface (carregamento, sucesso, erro e lista vazia com `FutureBuilder`).

## Escopo

A persistência dos dados deve ser realizada remotamente via requisições HTTP utilizando a biblioteca **Dio**, consumindo a API mock provida pelo `json-server`. Nenhuma operação de gravação deve ser mantida apenas em memória volátil; a API é a única fonte da verdade.

## O que será praticado

- Comunicação com APIs REST e tratamento assíncrono (`Future`, `async/await`).
- Utilização dos verbos HTTP com a semântica correta:
  - **GET**: Consulta geral, filtrada via Query Parameters e consumo de entidades relacionadas.
  - **POST**: Criação de recursos com envio de payload JSON e vínculo relacional (`clienteId`).
  - **PUT**: Substituição integral de um recurso existente.
  - **DELETE**: Exclusão de recursos no servidor.
- Mapeamento e desserialização de modelos no Dart (`PedidoModel` e `ClienteModel`).
- Tratamento de estados assíncronos na UI (`ConnectionState.waiting`, falha de conexão e lista vazia com `FutureBuilder`).

---

## Modelagem de Dados

### 1. `ClienteModel`
Representa os clientes cadastrados na base:

```dart
class ClienteModel {
  final int id;
  final String nome;
  final String telefone;
  final String endereco;

  ClienteModel({
    required this.id,
    required this.nome,
    required this.telefone,
    required this.endereco,
  });

  factory ClienteModel.fromMap(Map<String, dynamic> map) {
    return ClienteModel(
      id: map['id'],
      nome: map['nome'],
      telefone: map['telefone'],
      endereco: map['endereco'],
    );
  }
}
```

### 2. `PedidoModel`
Representa as solicitações de entrega vinculadas a um cliente:

```dart
class PedidoModel {
  final int id;
  final int clienteId;
  final String descricao;
  final double valorTotal;
  final String status; // "pendente", "em_preparo", "a_caminho", "entregue" ou "cancelado"
  final bool pago;
  final String? criadoEm;

  PedidoModel({
    required this.id,
    required this.clienteId,
    required this.descricao,
    required this.valorTotal,
    required this.status,
    required this.pago,
    this.criadoEm,
  });

  factory PedidoModel.fromMap(Map<String, dynamic> map) {
    return PedidoModel(
      id: map['id'],
      clienteId: map['clienteId'],
      descricao: map['descricao'],
      valorTotal: (map['valorTotal'] as num).toDouble(),
      status: map['status'],
      pago: map['pago'],
      criadoEm: map['criadoEm'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'clienteId': clienteId,
      'descricao': descricao,
      'valorTotal': valorTotal,
      'status': status,
      'pago': pago,
      'criadoEm': criadoEm,
    };
  }
}
```

> **Atenção à Desserialização:** O campo `valorTotal` na API pode ser interpretado pelo parser como `int` caso venha sem casas decimais (ex: `65`). Utilize `(map['valorTotal'] as num).toDouble()` para evitar quebras por tipagem.

---

## Operações Esperadas & Mapeamento HTTP

Organize a comunicação nas classes de serviço correspondentes (`PedidosService` e `ClientesService`):

### Clientes
1. **Listar Clientes (GET /clientes):**
   * Consultar os clientes disponíveis para preencher a seleção (ex: `DropdownButtonFormField`) no formulário de criação/edição do pedido.

### Pedidos
2. **Listar Pedidos (GET /pedidos):**
   * Consultar e listar todos os pedidos cadastrados.
   * Apresentar `CircularProgressIndicator` durante o carregamento.
   * Exibir mensagens claras caso a lista venha vazia ou ocorra falha de rede via `FutureBuilder`.

3. **Filtrar por Status (GET /pedidos?status={valor}):**
   * Permitir filtrar os pedidos por situação (ex: "pendente", "em_preparo") utilizando **Query Parameters** no Dio.

4. **Cadastrar Pedido (POST /pedidos):**
   * Enviar os dados no corpo (body) da requisição, associando o `clienteId` selecionado.
   * Não envie o campo `id`; o servidor o gerará automaticamente.
   * Validar se a descrição não está vazia e se o valor é maior que zero antes de disparar a requisição.

5. **Edição Integral (PUT /pedidos/:id):**
   * Atualizar os dados do pedido enviando o payload completo com todos os campos preservados.

6. **Cancelar/Remover Pedido (DELETE /pedidos/:id):**
   * Solicitar confirmação do usuário (via diálogo) e, ao confirmar, enviar a requisição `DELETE`, recarregando a listagem em caso de sucesso.

---

## Interface e Organização

A interface é responsabilidade do aluno. É fundamental que a aplicação:
* Utilize `FutureBuilder` para renderizar os estados da consulta assíncrona.
* Forneça feedback ao usuário via `SnackBar` ou diálogo nas operações de gravação e exclusão.
* Permita recarregar a lista manualmente (botão de refresh).

---

## 🎨 Especificação de Design Minimalista & Eficiente (Material 3)

> **Diretriz de Produtividade:** Foco no uso de widgets nativos do Flutter de alto nível (`ListTile`, `Card`, `CircleAvatar`), eliminando layouts manuais complexos e reduzindo o tempo de codificação em mais de 50%, sem comprometer nenhum requisito avaliado.

### 1. Paleta Semântica Direta (`Colors.*`)

Uso direto de constantes puras da classe `Colors` (sem shades ou hexadecimais complexos):

| Status / Propriedade | Cor Flutter | Ícone Nativo |
| :--- | :--- | :--- |
| **`pendente`** | `Colors.orange` | `Icons.schedule` |
| **`em_preparo`** | `Colors.blue` | `Icons.soup_kitchen` |
| **`a_caminho`** | `Colors.purple` | `Icons.delivery_dining` |
| **`entregue`** | `Colors.green` | `Icons.check_circle` |
| **`cancelado`** | `Colors.red` | `Icons.cancel` |
| **`pago: true`** | `Colors.green` | `Icons.check` |
| **`pago: false`** | `Colors.red` | `Icons.close` |

---

### 2. Wireframes Minimalistas (Componentes Nativos)

#### 2.1. Tela Principal: `PedidosPage` (Padrão `Card` + `ListTile`)
Aproveita a estrutura pronta do `ListTile` (`leading`, `title`, `subtitle`, `trailing`), reduzindo o código a poucas linhas:

```text
+-------------------------------------------------------------+
| Delivery Hub                                        Refresh | <- AppBar
+-------------------------------------------------------------+
| FILTROS:      [ Todos ] [ Pendente ] [ Em Preparo ] ...     | <- FilterChips (Horizontal)
+-------------------------------------------------------------+
|                                                             |
| +---------------------------------------------------------+ |
| | (O)  Pedido #2 - R$ 65,00                               | | <- Card com ListTile
| | Ícone 2x Hambúrguer Artesanal, 1x Fritas  Editar Excluir| |    leading: CircleAvatar
| |       Status: pendente | Pago: Não                      | |    title: Pedido + Valor
| +---------------------------------------------------------+ |    subtitle: Itens + Info
|                                                             |    trailing: Ações
| +---------------------------------------------------------+ |
| | (O)  Pedido #1 - R$ 78,50                               | |
| | Ícone 1x Pizza Calabresa, Guaraná 2L      Editar Excluir| |
| |       Status: em_preparo | Pago: Sim                    | |
| +---------------------------------------------------------+ |
|                                                             |
|                                                     [ + ]   | <- FloatingActionButton
+-------------------------------------------------------------+
```

#### 2.2. Variações do Corpo da Tela (`FutureBuilder`)
Tratamento enxuto dos 3 estados obrigatórios com widgets nativos simples:

```text
A) Carregando:           B) Erro de Conexão:        C) Lista Vazia:
+---------------------+  +-----------------------+  +----------------------+
|                     |  |                       |  |                      |
|                     |  |   Erro ao carregar    |  |    Nenhum pedido     |
|   Carregando...     |  |   [Tentar Novamente]  |  |      encontrado      |
+---------------------+  +-----------------------+  +----------------------+
```

#### 2.3. Diálogo de Confirmação de Exclusão (`AlertDialog`)
```text
         +-----------------------------------------------+
         | Excluir Pedido                                |
         +-----------------------------------------------+
         | Deseja realmente excluir o Pedido #2?         |
         |                                               |
         |           [ CANCELAR ]   [ EXCLUIR ]          |
         +-----------------------------------------------+
```

#### 2.4. Formulário Minimalista: `PedidoFormPage`
Construído com formulário padrão vertical sem decorações excessivas:

```text
+-------------------------------------------------------------+
| [<-] Novo Pedido / Editar Pedido                            |
+-------------------------------------------------------------+
|                                                             |
| [ Cliente: Mariana Souza                                [v] ] <- DropdownButtonFormField
|                                                             |
| [ Descrição dos itens...                                    ] <- TextFormField (multiline)
|                                                             |
| [ Valor Total (ex: 65.00)                                   ] <- TextFormField (numérico)
|                                                             |
| [ Status: Pendente                                      [v] ] <- DropdownButtonFormField
|                                                             |
| [X] Pedido já foi pago?                                     | <- SwitchListTile
|                                                             |
| [                       SALVAR PEDIDO                     ] | <- FilledButton / ElevatedButton
+-------------------------------------------------------------+
```

---

### 3. Mapeamento Direto do Pedido #2 (`db.json` linha 32) na Interface

> **Foco na Simplicidade:** Mapeamento 1:1 com interpolação de strings direta do Dart, sem exigir pacotes externos (como `intl`) ou formatações complexas (`padLeft`, parsing de data):

| Campo no JSON | Dado Mock | Como Exibir no Flutter | Código Direto Recomendado |
| :--- | :--- | :--- | :--- |
| `id` | `2` | `Pedido #2` | `'Pedido #${pedido.id}'` (interpolação direta, sem `padLeft`) |
| `clienteId` | `2` | `Cliente ID: 2` | `'Cliente ID: ${pedido.clienteId}'` *(evita ter que cruzar dados na lista)* |
| `descricao` | `"2x Hambúrguer..."` | `2x Hambúrguer...` | `Text(pedido.descricao)` |
| `valorTotal` | `65.0` | `R$ 65.00` | `'R$ ${pedido.valorTotal.toStringAsFixed(2)}'` |
| `status` | `"pendente"` | `Status: pendente` | `'Status: ${pedido.status}'` |
| `pago` | `false` | `Pago: Não` | `pedido.pago ? 'Pago: Sim' : 'Pago: Não'` |
| `criadoEm` | `"2026-10-30T..."` | _Opcional_ | Não é obrigatório exibir na listagem para simplificar o card |

---

### Estrutura Sugerida

```text
lib/
  main.dart
  api/
    api_config.dart          # Configuração da URL base dinâmica por plataforma (já inclusa)
  models/
    cliente_model.dart       # A ser criado pelo aluno
    pedido_model.dart        # A ser criado pelo aluno
  services/
    clientes_service.dart    # Consumo HTTP de /clientes (GET)
    pedidos_service.dart     # Consumo HTTP de /pedidos (GET, POST, PUT, DELETE)
  pages/
    pedidos_page.dart        # Listagem e controle visual com FutureBuilder
    pedido_form_page.dart    # Formulário de cadastro/edição com seleção de cliente
```

---

## 📡 Especificação dos Endpoints (Contrato da API)

Base URL: `http://localhost:3000` (ou `http://10.0.2.2:3000` no emulador Android)

| Método | Endpoint | Query / Body (Payload) | Status Esperado | Descrição |
| :--- | :--- | :--- | :---: | :--- |
| **GET** | `/clientes` | _Nenhum_ | `200 OK` | Retorna a lista de todos os clientes cadastrados. |
| **GET** | `/pedidos` | _Nenhum_ | `200 OK` | Retorna a lista de todos os pedidos. |
| **GET** | `/pedidos?status={valor}` | Query Param: `status` (ex: `pendente`) | `200 OK` | Retorna apenas os pedidos com o status correspondente. |
| **POST** | `/pedidos` | Body: `{ "clienteId": int, "descricao": string, "valorTotal": double, "status": string, "pago": bool, "criadoEm": string }` | `201 Created` | Cria um novo pedido. O campo `id` é gerado automaticamente pelo servidor. |
| **PUT** | `/pedidos/:id` | Body: `{ "clienteId": int, "descricao": string, "valorTotal": double, "status": string, "pago": bool, "criadoEm": string }` | `200 OK` | Substitui e atualiza integralmente os dados do pedido com o ID informado. |
| **DELETE** | `/pedidos/:id` | _Nenhum_ | `200 OK` | Remove o pedido correspondente ao ID informado. |

---

## Como Executar

A execução do projeto requer **dois terminais**: um para o servidor mock e outro para o aplicativo Flutter.

### 1️⃣ Inicializando a API Mock (Terminal 1)

Na raiz do projeto:

```bash
# Instala as dependências do servidor mock (apenas na primeira execução)
npm run setup

# Inicia a API REST mock na porta 3000
npm start
```

### 2️⃣ Executando o Aplicativo Flutter (Terminal 2)

```bash
flutter pub get
flutter run
```

### 🌐 Resolução de Rede & Plataformas

O endereço da API varia de acordo com o ambiente de execução:

| Ambiente | Endereço Base | Observações |
| :--- | :--- | :--- |
| **Navegador Web / Desktop** | `http://localhost:3000` | Funciona nativamente |
| **Simulador iOS** | `http://localhost:3000` | Compartilha o localhost do host |
| **Emulador Android** | `http://10.0.2.2:3000` | O alias `10.0.2.2` mapeia para o localhost do computador |
| **Dispositivo Físico USB** | `http://localhost:3000` | Requer executar: `adb reverse tcp:3000 tcp:3000` |
