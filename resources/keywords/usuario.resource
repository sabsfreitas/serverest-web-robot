*** Settings ***
Documentation    Keywords específicas para operações de usuário.
Library          RequestsLibrary
Library          Collections
Library          DateTime
Resource         ../variables.resource

*** Keywords ***
Gerar Email Unico
    [Documentation]    Gera um e-mail único baseado no timestamp com milissegundos.

    ${timestamp}=    Get Time    epoch
    ${microseconds}=    Evaluate    int(time.time() * 1000000) % 1000000    modules=time
    ${random}=    Evaluate    random.randint(1000, 9999)    modules=random
    ${unique_email}=    Set Variable    qa${timestamp}${microseconds}${random}@exemplo.com

    RETURN    ${unique_email}

Cadastrar Usuário Válido
    [Documentation]    Cadastra usuário válido e retorna dados
    [Arguments]    ${nome}=QA User Automated    ${administrador}=true

    ${email}=    Gerar Email Unico
    ${payload}=    Create Dictionary
    ...    nome=${nome}
    ...    email=${email}
    ...    password=${VALID_PASSWORD}
    ...    administrador=${administrador}
    ${response}=    POST On Session    serverest    /usuarios    json=${payload}    expected_status=201

    Should Be Equal As Strings    ${response.status_code}    201
    Dictionary Should Contain Key    ${response.json()}    _id
    Dictionary Should Contain Key    ${response.json()}    message
    Should Match Regexp    ${response.json()['message']}    (?i)cadastro.*sucesso
    
    VAR    ${USER_EMAIL}    ${email}    scope=SUITE
    VAR    ${USER_PASS}     ${VALID_PASSWORD}    scope=SUITE

    RETURN    ${response}    ${email}

Cadastrar Usuário Com E-mail Duplicado
    [Documentation]    Tenta cadastrar usuário com email duplicado
    [Arguments]    ${email_existente}

    ${payload}=    Create Dictionary
    ...    nome=Outro Usuario
    ...    email=${email_existente}
    ...    password=${VALID_PASSWORD}
    ...    administrador=false
    ${response}=    POST On Session    serverest    /usuarios    json=${payload}    expected_status=400

    Should Be Equal As Strings    ${response.status_code}    400
    Dictionary Should Not Contain Key    ${response.json()}    _id
    Should Match Regexp    ${response.json()['message']}    (?i)já.*sendo usado

    RETURN    ${response}

Cadastrar Usuário Com E-mail Inválido
    [Documentation]    Tenta cadastrar usuário com email inválido
    [Arguments]    ${email_invalido}

    ${payload}=    Create Dictionary
    ...    nome=Usuario Teste
    ...    email=${email_invalido}
    ...    password=${VALID_PASSWORD}
    ...    administrador=true
    ${response}=    POST On Session    serverest    /usuarios    json=${payload}    expected_status=400

    Should Be Equal As Strings    ${response.status_code}    400
    Dictionary Should Not Contain Key    ${response.json()}    _id
    Dictionary Should Contain Key    ${response.json()}    email
    Should Match Regexp    ${response.json()['email']}    (?i)email.*válido

    RETURN    ${response}

Cadastrar Usuário Com Senha Inválida
    [Documentation]    Tenta cadastrar usuário com senha inválida
    [Arguments]    ${senha_invalida}    ${regex_esperado}

    ${email}=    Gerar Email Unico
    ${payload}=    Create Dictionary
    ...    nome=Usuario Senha Invalida
    ...    email=${email}
    ...    password=${senha_invalida}
    ...    administrador=true
    ${response}=    POST On Session    serverest    /usuarios    json=${payload}    expected_status=400

    Should Be Equal As Strings    ${response.status_code}    400
    Dictionary Should Not Contain Key    ${response.json()}    _id
    Dictionary Should Contain Key    ${response.json()}    password
    Should Match Regexp    ${response.json()['password']}    ${regex_esperado}

    RETURN    ${response}

Cadastrar Usuário Com Domínio Bloqueado
    [Documentation]    Tenta cadastrar usuário com domínio bloqueado
    [Arguments]    ${dominio}

    ${timestamp}=    Get Time    epoch
    ${email}=    Set Variable    teste${timestamp}${dominio}
    ${payload}=    Create Dictionary
    ...    nome=Usuario Dominio Bloqueado
    ...    email=${email}
    ...    password=${VALID_PASSWORD}
    ...    administrador=true
    ${response}=    POST On Session    serverest    /usuarios    json=${payload}    expected_status=400

    Should Be Equal As Strings    ${response.status_code}    400
    Dictionary Should Not Contain Key    ${response.json()}    _id
    Dictionary Should Contain Key    ${response.json()}    email
    Should Match Regexp    ${response.json()['email']}    (?i)não.*permitid|bloquead|domínio

    RETURN    ${response}

Cadastrar Usuário Com Campos Vazios
    [Documentation]    Tenta cadastrar usuário com campos obrigatórios vazios

    ${payload}=    Create Dictionary
    ...    nome=${EMPTY}
    ...    email=${EMPTY}
    ...    password=${EMPTY}
    ...    administrador=true
    ${response}=    POST On Session    serverest    /usuarios    json=${payload}    expected_status=400

    Should Be Equal As Strings    ${response.status_code}    400
    Dictionary Should Not Contain Key    ${response.json()}    _id
    Dictionary Should Contain Key    ${response.json()}    nome
    Dictionary Should Contain Key    ${response.json()}    email
    Dictionary Should Contain Key    ${response.json()}    password

    RETURN    ${response}

Buscar Usuário Inexistente
    [Documentation]    Tenta buscar usuário inexistente
    [Arguments]    ${user_id_inexistente}

    ${response}=    GET On Session    serverest    /usuarios/${user_id_inexistente}    expected_status=400
    Should Be Equal As Strings    ${response.status_code}    400
    Dictionary Should Contain Key    ${response.json()}    message
    Should Match Regexp    ${response.json()['message']}    (?i)usuário.*não.*encontrad

    RETURN    ${response}

Deletar Usuário
    [Documentation]    Deleta um usuário existente
    [Arguments]    ${user_id} 

    ${response}=    DELETE On Session    serverest    /usuarios/${user_id}   expected_status=200

    Should Be Equal As Strings    ${response.status_code}    200
    Dictionary Should Contain Key    ${response.json()}    message
    Should Match Regexp    ${response.json()['message']}    (?i)registro.*excluído.*sucesso

    RETURN    ${response}

Atualizar Usuário com ID Inexistente
    [Documentation]    Testa atualizar um usuário inexistente e cria novo usuário
    [Arguments]    ${user_id_inexistente}    ${novo_nome}=Nome Atualizado

    ${payload}=    Create Dictionary
    ...    nome=${novo_nome}
    ...    email=${VALID_EMAIL}
    ...    password=${VALID_PASSWORD}
    ...    administrador=false
    ${response}=    PUT On Session    serverest    /usuarios/${user_id_inexistente}    json=${payload}    expected_status=201

    Should Be Equal As Strings    ${response.status_code}    201
    Dictionary Should Contain Key    ${response.json()}    message
    Should Match Regexp    ${response.json()['message']}    (?i)cadastro.*sucesso

    RETURN    ${response}