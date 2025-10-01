*** Settings ***
Documentation     Testes de Ações com Usuários - ServeRest API
Library           RequestsLibrary
Resource          ../resources/variables.resource
Resource          ../resources/keywords/usuario.resource
Suite Setup       Create Session    serverest    ${BASE_URL}
Suite Teardown    Delete All Sessions

*** Variables ***
${USER_ID}        ${EMPTY}
${VALID_EMAIL}    ${EMPTY}

*** Test Cases ***
CT001 - Cadastro de Usuário Válido
    [Tags]    positivo    critico    AC1
    [Documentation]    Testa o cadastro de um usuário com todos os campos válidos
    ${response}    ${email}=    Cadastrar Usuario Valido
    Set Suite Variable    ${USER_ID}    ${response.json()['_id']}
    Set Suite Variable    ${VALID_EMAIL}    ${email}

CT002 - Cadastro com E-mail Duplicado
    [Tags]    negativo    critico    AC3
    [Documentation]    Testa que não é possível cadastrar usuário com e-mail já existente
    Cadastrar Usuario Com Email Duplicado    ${VALID_EMAIL}

CT003 - Cadastro com E-mail Inválido
    [Tags]    negativo    alto    AC7
    [Documentation]    Testa que não é possível cadastrar usuário com formato de e-mail inválido
    Cadastrar Usuario Com Email Invalido    ${INVALID_EMAIL}

CT004 - Cadastro com Senha Muito Curta
    [Tags]    negativo    alto    AC8    bva
    [Documentation]    Testa que não é possível cadastrar usuário com senha menor que 5 caracteres
    Cadastrar Usuario Com Senha Invalida    ${SHORT_PASSWORD}    (?i)mínimo|minim|5

CT005 - Cadastro com Senha Muito Longa
    [Tags]    negativo    alto    AC8    bva
    [Documentation]    Testa que não é possível cadastrar usuário com senha maior que 10 caracteres
    Cadastrar Usuario Com Senha Invalida    ${LONG_PASSWORD}    (?i)máximo|maxim|10

CT006 - Cadastro com E-mail Gmail Bloqueado
    [Tags]    negativo    medio    AC6
    [Documentation]    Testa que não é possível cadastrar usuário com domínio gmail.com
    Cadastrar Usuario Com Dominio Bloqueado    @gmail.com

CT007 - Cadastro com E-mail Hotmail Bloqueado
    [Tags]    negativo    medio    AC6
    [Documentation]    Testa que não é possível cadastrar usuário com domínio hotmail.com
    Cadastrar Usuario Com Dominio Bloqueado    @hotmail.com

CT008 - Cadastro com Campos Vazios
    [Tags]    negativo    medio
    [Documentation]    Testa que não é possível cadastrar usuário com campos obrigatórios vazios
    Cadastrar Usuario Com Campos Vazios

CT009 - Cadastro com Senha no Limite Mínimo Válido
    [Tags]    positivo    bva    AC8
    [Documentation]    Testa cadastro com senha de exatamente 5 caracteres (limite mínimo válido)
    Cadastrar Usuario Valido    Usuario Limite Min    false

CT010 - Cadastro com Senha no Limite Máximo Válido
    [Tags]    positivo    bva    AC8
    [Documentation]    Testa cadastro com senha de exatamente 10 caracteres (limite máximo válido)
    Cadastrar Usuario Valido    Usuario Limite Max    false

CT011 - Buscar Usuário Inexistente
    [Tags]    negativo    medio
    [Documentation]    Testa que não é possível buscar um usuário inexistente (16 caracteres alfanuméricos)
    Buscar Usuario Inexistente    0000000000000000