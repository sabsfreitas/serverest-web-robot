*** Settings ***
Documentation     Testes de ações com Carrinho.

Library           RequestsLibrary

Resource          ../resources/variables.resource
Resource          ../resources/keywords/carrinho.resource

Suite Setup       Setup e Autenticar na Suite
Suite Teardown    Delete All Sessions

*** Test Cases ***
Cenário 01: Cadastrar Produto ao Carrinho
    [Documentation]    Testa adicionar um produto ao carrinho de um usuário
    [Tags]    positivo    carrinho    adicionar
    Adicionar Produto no Carrinho    ${AUTH_TOKEN}

Cenário 02: Concluir Compra
    [Documentation]    Testa concluir a compra do carrinho de um usuário
    [Tags]    positivo    carrinho    concluir
    Concluir Compra    ${AUTH_TOKEN}

Cenário 03: Cancelar Compra
    [Documentation]    Testa cancelar a compra do carrinho de um usuário
    [Tags]    positivo    carrinho    cancelar
    Cancelar Compra    ${AUTH_TOKEN}