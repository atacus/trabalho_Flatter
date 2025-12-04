# 📱 Viva Higienizado – Aplicativo Móvel

**Aluno:** Elias de Jesus Miranda  
**E-mail:** elias.miranda@solahic.com.br  
**Disciplina:** Desenvolvimento de Aplicativos para Dispositivos Móveis  
**Curso:** Bacharelado em Sistemas de Informação  

---

## 🎯 Tema do Projeto

**Gestão de Serviços de Higienização e Turismo Local**  

Este aplicativo permite que profissionais registrem serviços de limpeza e manutenção em locais turísticos ou comerciais, documentando cada serviço com **fotos, vídeos** e **coordenadas GPS**. O objetivo é centralizar informações, permitir acompanhamento em tempo real e fornecer dados precisos para gestão de qualidade.

---

## 💡 Motivos da Escolha da API Semi-Profissional

Durante o desenvolvimento do trabalho final, utilizamos inicialmente uma **API semi-profissional** simulando o comportamento esperado da API final da Viva Higienizado, o que trouxe vantagens como:

- **Testes independentes**: permitiu validar login, cadastro, listagem de serviços e upload de mídias sem depender da API final.  
- **Controle de autenticação**: fluxo de login seguro com token JWT armazenado localmente (`flutter_secure_storage`).  
- **Escalabilidade**: fácil substituição dos endpoints de teste pela API final da Viva Higienizado.  
- **Validação de funcionalidades críticas**: upload de fotos, vídeos e GPS já implementado e pronto para integração final.

---

## ⚙️ Funcionalidades Implementadas

1. **Autenticação de usuários**  
   - Login seguro via token JWT.  
   - Logout que remove token garantindo segurança de sessão.

2. **Gestão de serviços**  
   - Listagem de serviços com detalhes.  
   - Cadastro de novos serviços (nome do cliente, telefone, email, descrição).  

3. **Captura e upload de mídia + GPS**  
   - Upload de fotos antes e depois do serviço.  
   - Upload de vídeos relacionados ao serviço.  
   - Registro de coordenadas GPS do serviço.  
   - Envio via `http.MultipartRequest`, compatível com a API final.  

4. **Código modular e organizado**  
   - Pastas separadas por **controllers**, **models**, **screens**, **services** e **widgets**.  
   - Componentes reutilizáveis e fácil manutenção.  

---

## 📂 Estrutura do Projeto

lib/
├── controllers
├── main.dart
├── midia_model.dart
├── models
│   ├── midia_model.dart
│   └── servico_model.dart
├── screens
│   ├── captura_midia_screen.dart
│   ├── detalhe_servico_screen.dart
│   ├── lista_servicos_screen.dart
│   └── login_screen.dart
├── services
│   ├── api_service.dart
│   ├── login_controller.dart
│   ├── servicos_controller.dart
│   └── upload_service.dart
└── widgets
    ├── card_servico.dart
    └── midia_uploader.dart

---

## 🔧 Tecnologias e Ferramentas Utilizadas

- **Linguagem:** Dart  
- **Framework:** Flutter  
- **Gerenciamento de estado:** Controllers + Navigator  
- **Autenticação:** Tokens JWT com `flutter_secure_storage`  
- **Upload de mídias:** `http.MultipartRequest` (fotos e vídeos)  
- **Integração API:** Inicialmente semi-profissional, facilmente escalável para a API da Viva Higienizado  
- **Dispositivos suportados:** Android, iOS e Linux (desktop)  

---

## 📌 Considerações Técnicas

- O controle de usuário e token garante acesso seguro às funcionalidades do aplicativo.  
- O upload de fotos, vídeos e GPS está totalmente implementado, permitindo integração direta com a API final.  
- Estrutura modular garante fácil manutenção e adição de novas funcionalidades.  
- Escalabilidade pensada para migração rápida e segura para a API real da Viva Higienizado.

---

## 🚀 Como Executar

1. **Clonar o repositório:**

```bash
git clone <url-do-repositorio>
cd vivahigienizado

### Instalar dependências:
flutter pub get

## Executar em modo debug:(personalizado)
./rundev.sh


