*** Settings ***
Documentation     Testes de ações com Produtos.
Library           RequestsLibrary
Resource          ../resources/variables.resource
Resource          ../resources/keywords/login.resource
Resource          ../resources/keywords/produto.resource
Resource          ../resources/keywords/carrinho.resource

Suite Setup       Setup e Autenticar na Suite
Suite Teardown    Delete All Sessions
*** Variables ***
${AUTH_TOKEN}     ${EMPTY}
*** Test Cases ***
Cenário 01: Cadastrar Produto com Sucesso
    [Documentation]    Testa o cadastro de um produto com sucesso usando o token global
    [Tags]    positivo    produto    cadastro
    Cadastrar Novo Produto    ${AUTH_TOKEN}

Cenário 02: Cadastrar Produto com Nome Duplicado
    [Documentation]    Testa que não é possível cadastrar dois produtos com o mesmo nome
    [Tags]    negativo    produto    duplicidade
    ${response1}    ${nome_produto}=    Cadastrar Novo Produto    ${AUTH_TOKEN}
    ${response2}=    Cadastrar Produto com Nome Duplicado    ${nome_produto}    ${AUTH_TOKEN}

Cenário 03: Cadastrar Produto Não Sendo Admin
    [Documentation]    Testa que não é possível cadastrar um produto usando o token de um usuário não administrador
    [Tags]    negativo    produto    permissão
    ${token_user}=    Gerar Token Usuário Comum
    Cadastrar Produto Não Sendo Admin    ${token_user}

Cenário 04: Cadastrar Produto com Token Inválido
    [Documentation]    Testa que não é possível cadastrar um produto usando um token inválido
    [Tags]    negativo    produto    autenticação
    Cadastrar Produto com Token Inválido    InvalidToken123

Cenário 05: Listar Produtos
    [Documentation]    Testa a listagem de produtos
    [Tags]    positivo    produto    listagem
    Listar Produtos

Cenário 06: Excluir Produto com Carrinho
    [Documentation]    Testa que não é possível excluir um produto que está em um carrinho
    [Tags]    negativo    produto    exclusão
    ${response_produto}    ${nome_produto}=    Cadastrar Novo Produto    ${AUTH_TOKEN}
    ${produto_id}=    Set Variable    ${response_produto.json()['_id']}
    ${token_user}=    Gerar Token Usuário Comum
    ${response_carrinho}=    Adicionar Produto Existente no Carrinho    ${token_user}    ${produto_id}
    Excluir Produto com Carrinho    ${produto_id}    ${AUTH_TOKEN}