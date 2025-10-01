*** Settings ***
Documentation     Testes de Permissão de Admin - ServeRest API
Library           RequestsLibrary
Resource          ../resources/variables.resource
Resource          ../resources/keywords/admin.resource

Suite Setup       Setup User Session
Suite Teardown    Delete All Sessions

*** Test Cases ***

CT001 - Usuário Comum Não Deve Cadastrar Produto
    [Tags]    negativo    critico    AC12
    [Documentation]    Testa que usuário comum não pode cadastrar produtos
    ${token}=    Setup User Session
    Cadastro de produto bloqueado para usuário comum    ${token}