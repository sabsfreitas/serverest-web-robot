*** Settings ***
Documentation     Testes de ações com Auth.
Library           RequestsLibrary
Resource          ../resources/variables.resource
Resource          ../resources/keywords/usuario.resource
Resource          ../resources/keywords/login.resource

Suite Setup       Setup e Autenticar na Suite
Suite Teardown    Delete All Sessions

*** Test Cases ***
Cenário 01: Login com Usuário Válido
    [Tags]    positivo    critico    login
    [Documentation]    Testa login com usuário cadastrado válido
    Cadastrar Usuário Válido
    Realizar Login Com Usuário Cadastrado

Cenário 02: Login com Senha Inválida
    [Tags]    negativo    alto    login
    [Documentation]    Testa login com senha incorreta
    Realizar Login Com Credenciais Inválidas    ${USER_EMAIL}    senha_errada

Cenário 03: Login com E-mail Inexistente
    [Tags]    negativo    alto    login
    [Documentation]    Testa login com email não cadastrado
    Realizar Login Com Credenciais Inválidas    usuario_inexistente@teste.com    ${VALID_PASSWORD}

# Cenário 04: Token Expirado Após 10 Minutos
#     [Tags]    negativo    medio    login
#     [Documentation]    Testa que o token expira após 10 minutos
#     Expiração de Token Após 10 Minutos