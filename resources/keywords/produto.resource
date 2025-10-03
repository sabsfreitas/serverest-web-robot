*** Settings ***
Documentation    Keywords específicas para operações de produto
Library          RequestsLibrary
Library          Collections
Library          DateTime
Resource         ../variables.resource
Resource         login.resource

*** Keywords ***
Gerar Nome Produto Único
    [Documentation]    Gera um nome de produto único baseado no timestamp com milissegundos e número aleatório.
    ${timestamp}=    Get Time    epoch
    ${microseconds}=    Evaluate    int(time.time() * 1000000) % 1000000    modules=time
    ${random}=    Evaluate    random.randint(1000, 9999)    modules=random
    ${unique_name}=    Set Variable    Produto${timestamp}${microseconds}${random}
    RETURN    ${unique_name}

Cadastrar Novo Produto
    [Documentation]    Cadastra um produto válido. Se o nome não for passado, gera um automaticamente.
    ...                Requer um token de autenticação como argumento.

    [Arguments]        ${token}    ${nome}=None    ${preco}=199    ${descricao}=Produto de Teste    ${quantidade}=10

    ${nome_produto}=    Run Keyword If    '${nome}' == 'None'    Gerar Nome Produto Único
    ...                 ELSE              Set Variable    ${nome}

    ${payload}=        Create Dictionary
    ...                nome=${nome_produto}
    ...                preco=${preco}
    ...                descricao=${descricao}
    ...                quantidade=${quantidade}
    ${headers}=    Create Dictionary    Authorization=${token}
    ${response}=    POST On Session    serverest    /produtos    json=${payload}    headers=${headers}    expected_status=201
    
    Should Be Equal As Strings    ${response.status_code}    201
    Dictionary Should Contain Key    ${response.json()}    _id
    Dictionary Should Contain Key    ${response.json()}    message
    Should Match Regexp    ${response.json()['message']}    (?i)cadastro.*realizado.*sucesso

    RETURN    ${response}    ${nome_produto}

Cadastrar Produto com Nome Duplicado
    [Documentation]    Tenta cadastrar um produto com um nome já existente.
    ...                Requer o nome e um token de autenticação.
    [Arguments]    ${nome_existente}    ${token}

    ${payload}=    Create Dictionary
    ...    nome=${nome_existente}
    ...    preco=150
    ...    descricao=Produto Duplicado Teste
    ...    quantidade=5
    ${headers}=    Create Dictionary    Authorization=${token}
    ${response}=    POST On Session    serverest    /produtos    json=${payload}    headers=${headers}    expected_status=400

    Should Be Equal As Strings    ${response.status_code}    400
    Dictionary Should Not Contain Key    ${response.json()}    _id
    Should Match Regexp    ${response.json()['message']}    (?i)já.*existe.*produto

    RETURN    ${response}

Cadastrar Produto Não Sendo Admin
    [Documentation]    Tenta cadastrar um produto usando um token de usuário não administrador.
    [Arguments]    ${token}
    
    ${nome_produto}=    Gerar Nome Produto Único
    ${payload}=    Create Dictionary
    ...    nome=${nome_produto}
    ...    preco=100
    ...    descricao=Teste Produto Não Admin
    ...    quantidade=3
    ${headers}=    Create Dictionary    Authorization=${token}
    ${response}=    POST On Session    serverest    /produtos    json=${payload}    headers=${headers}    expected_status=403

    Should Be Equal As Strings    ${response.status_code}    403
    Should Match Regexp    ${response.json()['message']}    (?i)exclusiva.*administradores

    RETURN    ${response}

Cadastrar Produto com Token Inválido
    [Documentation]    Tenta cadastrar um produto usando um token inválido.
    [Arguments]    ${invalid_token}
    
    ${nome_produto}=    Gerar Nome Produto Único
    ${payload}=    Create Dictionary
    ...    nome=${nome_produto}
    ...    preco=100
    ...    descricao=Teste Produto Token Inválido
    ...    quantidade=3
    ${headers}=    Create Dictionary    Authorization=${invalid_token}
    ${response}=    POST On Session    serverest    /produtos    json=${payload}    headers=${headers}    expected_status=401

    Should Be Equal As Strings    ${response.status_code}    401
    Should Match Regexp    ${response.json()['message']}    (?i)token.*inválido

    RETURN    ${response}

Listar Produtos
    [Documentation]    Lista todos os produtos cadastrados.

    ${response}=    GET On Session    serverest    /produtos    expected_status=200

    Should Be Equal As Strings    ${response.status_code}    200
    Dictionary Should Contain Key    ${response.json()}    produtos
    Should Not Be Empty    ${response.json()['produtos']}
    
    RETURN    ${response}