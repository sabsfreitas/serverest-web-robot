*** Settings ***
Documentation    Keywords reutilizáveis para operações de carrinho.

Library          RequestsLibrary
Library          Collections

Resource         ../variables.resource
Resource        login.resource
Resource        produto.resource

*** Keywords ***

Adicionar Produto no Carrinho
    [Documentation]    Adiciona um produto ao carrinho de um usuário
    [Arguments]    ${token}    ${quantidade}=1

    ${response_produto}    ${nome_produto}=    Cadastrar Novo Produto    ${token}

    ${produto_id}=    Set Variable    ${response_produto.json()['_id']}
    ${produto_item}=    Create Dictionary    idProduto=${produto_id}    quantidade=${quantidade}
    ${produtos_array}=    Create List    ${produto_item}
    ${payload}=    Create Dictionary    produtos=${produtos_array}
    ${headers}=    Create Dictionary    Authorization=${token}
    ${response}=    POST On Session    serverest    /carrinhos    json=${payload}    headers=${headers}    expected_status=201

    Should Be Equal As Strings    ${response.status_code}    201
    Dictionary Should Contain Key    ${response.json()}    message
    Should Match Regexp    ${response.json()['message']}    (?i)cadastro.*realizado.*sucesso

    RETURN    ${response}    ${produto_id}

Adicionar Produto Existente no Carrinho
    [Documentation]    Adiciona um produto existente ao carrinho de um usuário
    [Arguments]    ${token}    ${produto_id}    ${quantidade}=1

    ${produto_item}=    Create Dictionary    idProduto=${produto_id}    quantidade=${quantidade}
    ${produtos_array}=    Create List    ${produto_item}
    ${payload}=    Create Dictionary    produtos=${produtos_array}
    ${headers}=    Create Dictionary    Authorization=${token}
    ${response}=    POST On Session    serverest    /carrinhos    json=${payload}    headers=${headers}    expected_status=201

    Should Be Equal As Strings    ${response.status_code}    201
    Dictionary Should Contain Key    ${response.json()}    message
    Should Match Regexp    ${response.json()['message']}    (?i)cadastro.*realizado.*sucesso

    RETURN    ${response}

Concluir Compra
    [Documentation]    Conclui a compra do carrinho de um usuário
    [Arguments]    ${token}

    ${headers}=    Create Dictionary    Authorization=${token}
    ${response}=    DELETE On Session    serverest    /carrinhos/concluir-compra    headers=${headers}    expected_status=200

    Should Be Equal As Strings    ${response.status_code}    200
    Dictionary Should Contain Key    ${response.json()}    message
    Should Match Regexp    ${response.json()['message']}    (?i)registro.*excluído.*sucesso

    RETURN    ${response}

Cancelar Compra
    [Documentation]    Cancela a compra do carrinho de um usuário
    [Arguments]    ${token}

    ${response_carrinho}    ${produto_id}=    Adicionar Produto no Carrinho    ${token}

    ${headers}=    Create Dictionary    Authorization=${token}
    ${response}=    DELETE On Session    serverest    /carrinhos/cancelar-compra    headers=${headers}    expected_status=200
    
    Should Be Equal As Strings    ${response.status_code}    200
    Dictionary Should Contain Key    ${response.json()}    message
    Should Match Regexp    ${response.json()['message']}    (?i)registro.*excluído.*sucesso

    RETURN    ${response}