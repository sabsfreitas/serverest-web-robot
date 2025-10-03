*** Settings ***
Documentation     Keywords específicas para autenticação.
Library           RequestsLibrary
Resource          ../variables.resource
Resource          usuario.resource
Resource          produto.resource

*** Variables ***
${USER_EMAIL}    ${EMPTY}
${USER_PASS}     ${EMPTY}
${AUTH_TOKEN}    ${EMPTY}

*** Keywords ***

Setup e Autenticar na Suite
    [Documentation]    Cria sessão, cadastra usuário, faz login e salva credenciais/token no escopo da suíte.
    [Arguments]    ${nome_usuario}=QA User    ${isAdmin}=true

    Create Session    serverest    ${BASE_URL}
    
    ${response_cadastro}    ${email}=    Cadastrar Usuário Válido    ${nome_usuario}    ${isAdmin}
    VAR    ${USER_EMAIL}    ${email}              scope=SUITE
    VAR    ${USER_PASS}     ${VALID_PASSWORD}     scope=SUITE

    ${response_login}=    Realizar Login Com Usuário Cadastrado
    ${token}=    Set Variable    ${response_login.json()['authorization']}
    VAR    ${AUTH_TOKEN}    ${token}              scope=SUITE

Gerar Token Usuário Comum
    [Documentation]    Gera token de usuário não administrador

    ${response_user}    ${email}=    Cadastrar Usuário Válido    Usuario Comum    false
    ${login_data}=    Create Dictionary    email=${email}    password=${VALID_PASSWORD}
    ${response_login}=    POST On Session    serverest    /login    json=${login_data}    expected_status=200
    ${token_user}=    Set Variable    ${response_login.json()['authorization']}

    RETURN    ${token_user}


Realizar Login Com Usuário Cadastrado
    [Documentation]    Realiza login com um usuário válido.

    ${payload}=    Create Dictionary    email=${USER_EMAIL}    password=${USER_PASS}
    ${response}=    POST On Session    serverest    /login    json=${payload}    expected_status=200

    Should Be Equal As Strings    ${response.status_code}    200
    Dictionary Should Contain Key    ${response.json()}    authorization

    ${token}=    Set Variable    ${response.json()['authorization']}
    VAR    ${AUTH_TOKEN}    ${token}    scope=SUITE

    RETURN             ${response}

Realizar Login Com Credenciais Inválidas
    [Documentation]    Tenta realizar login com credenciais inválidas.
    [Arguments]        ${email}    ${password}

    ${data}=           Create Dictionary    email=${email}    password=${password}
    ${response}=       POST On Session      serverest    /login    json=${data}    expected_status=401

    Should Be Equal As Strings    ${response.status_code}    401
    Dictionary Should Contain Key    ${response.json()}    message
    Should Match Regexp    ${response.json()['message']}    (?i)email.*ou.*senha.*inválido

    RETURN    ${response}

Expiração de Token Após 10 Minutos
    [Documentation]    Testa que o token expira após 10 minutos.
    Sleep    600s
    ${payload}=    Create Dictionary    email=${USER_EMAIL}    password=${USER_PASS}
    ${response}=    POST On Session    serverest    /login    json=${payload}    expected_status=200
    Should Be Equal As Strings    ${response.status_code}    200
    Dictionary Should Contain Key    ${response.json()}    authorization

    ${token}=    Set Variable    ${response.json()['authorization']}
    VAR    ${AUTH_TOKEN}    ${token}    scope=SUITE

    ${headers}=    Create Dictionary    Authorization=${AUTH_TOKEN}

    ${response_protected}=    Cadastrar Produto com Token Inválido    ${headers}

    Should Be Equal As Strings    ${response_protected.status_code}    401
    Dictionary Should Contain Key    ${response_protected.json()}    message
    Should Match Regexp    ${response_protected.json()['message']}    (?i)token.*inválido.*expirado

    RETURN    ${response_protected}