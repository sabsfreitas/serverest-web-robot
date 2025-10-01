*** Settings ***
Documentation     Testes de Login - ServeRest API
Library           RequestsLibrary
Resource          ../resources/variables.resource
Resource          ../resources/keywords/usuario.resource
Resource          ../resources/keywords/login.resource

Suite Setup       Setup Login Tests
Suite Teardown    Delete All Sessions

*** Test Cases ***
CT001 - Login com Usuário Válido
    [Tags]    positivo    critico    login
    [Documentation]    Testa login com usuário cadastrado válido
    ${response}=    Realizar Login Com Usuario Cadastrado
    Dictionary Should Contain Key    ${response.json()}    authorization

CT002 - Login com Senha Inválida
    [Tags]    negativo    alto    login
    [Documentation]    Testa login com senha incorreta
    Realizar Login Com Credenciais Invalidas    ${LOGIN_EMAIL}    senha_errada

CT003 - Login com Email Inexistente
    [Tags]    negativo    alto    login
    [Documentation]    Testa login com email não cadastrado
    Realizar Login Com Credenciais Invalidas    usuario_inexistente@teste.com    ${VALID_PASSWORD}

CT004 - Token Expirado Após 10 Minutos
    [Tags]    negativo    medio    login
    [Documentation]    Testa que o token expira após 10 minutos
    Expiração de Token Após 10 Minutos