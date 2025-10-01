*** Settings ***
Documentation     Testes de Ações com Produtos - ServeRest API
Library           RequestsLibrary
Resource          ../resources/variables.resource
Resource          ../resources/keywords/produto.resource

Suite Setup       Setup Produtos Suite
Suite Teardown    Delete All Sessions

*** Test Cases ***

Cadastrar Produto com Sucesso
    [Documentation]    Testa o cadastro de um produto com sucesso usando o token global
    [Tags]    positivo    produto    cadastro
    ${response_produto}    ${nome_produto}=    Cadastrar Produto Valido
    Log    Produto cadastrado com sucesso: ${nome_produto}

Cadastrar Produto com Nome Duplicado
    [Documentation]    Testa que não é possível cadastrar dois produtos com o mesmo nome
    [Tags]    negativo    produto    duplicidade
    ${response1}    ${nome_produto}=    Cadastrar Produto Valido
    ${response2}=    Cadastrar Produto com Nome Duplicado    ${nome_produto}

Listar Produtos
    [Documentation]    Testa a listagem de produtos
    [Tags]    positivo    produto    listagem
    ${response}=    Listar Produtos
    Should Be Equal As Strings    ${response.status_code}    200
    Should Be Equal As Strings    ${response.status_code}    200