*** Settings ***
Documentation     Testes de ações com Usuários.
Library           RequestsLibrary
Resource          ../resources/variables.resource
Resource          ../resources/keywords/usuario.resource

Suite Setup       Create Session    serverest    ${BASE_URL}
Suite Teardown    Delete All Sessions

*** Test Cases ***
Cenário 01: Cadastro de Usuário Válido
    [Tags]    positivo    critico 
    [Documentation]    Testa o cadastro de um usuário com todos os campos válidos
    ${response}    ${email}=    Cadastrar Usuário Válido
    VAR            ${USER_ID}    ${response.json()['_id']}    scope=SUITE
    VAR            ${VALID_EMAIL}    ${email}    scope=SUITE

Cenário 02: Cadastro com E-mail Duplicado
    [Tags]    negativo    critico 
    [Documentation]    Testa que não é possível cadastrar usuário com e-mail já existente
    Cadastrar Usuário Com E-mail Duplicado    ${VALID_EMAIL}

Cenário 03: Cadastro com E-mail Inválido
    [Tags]    negativo    alto
    [Documentation]    Testa que não é possível cadastrar usuário com formato de e-mail inválido
    Cadastrar Usuário Com E-mail Inválido    ${INVALID_EMAIL}

Cenário 04: Cadastro com Senha Muito Curta
    [Tags]    negativo    alto    bva
    [Documentation]    Testa que não é possível cadastrar usuário com senha menor que 5 caracteres
    Cadastrar Usuário Com Senha Inválida    ${SHORT_PASSWORD}    (?i)mínimo|minim|5

Cenário 05: Cadastro com Senha Muito Longa
    [Tags]    negativo    alto    bva
    [Documentation]    Testa que não é possível cadastrar usuário com senha maior que 10 caracteres
    Cadastrar Usuário Com Senha Inválida    ${LONG_PASSWORD}    (?i)máximo|maxim|10

Cenário 06: Cadastro com E-mail Gmail Bloqueado
    [Tags]    negativo    medio
    [Documentation]    Testa que não é possível cadastrar usuário com domínio gmail.com
    Cadastrar Usuário Com Domínio Bloqueado    @gmail.com

Cenário 07: Cadastro com E-mail Hotmail Bloqueado
    [Tags]    negativo    medio
    [Documentation]    Testa que não é possível cadastrar usuário com domínio hotmail.com
    Cadastrar Usuário Com Domínio Bloqueado    @hotmail.com

Cenário 08: Cadastro com Campos Vazios
    [Tags]    negativo    medio
    [Documentation]    Testa que não é possível cadastrar usuário com campos obrigatórios vazios
    Cadastrar Usuário Com Campos Vazios

Cenário 09: Cadastro com Senha no Limite Mínimo Válido
    [Tags]    positivo    bva
    [Documentation]    Testa cadastro com senha de exatamente 5 caracteres (limite mínimo válido)
    Cadastrar Usuário Válido    Usuario Limite Min    false

Cenário 10: Cadastro com Senha no Limite Máximo Válido
    [Tags]    positivo    bva
    [Documentation]    Testa cadastro com senha de exatamente 10 caracteres (limite máximo válido)
    Cadastrar Usuário Válido    Usuario Limite Max    false

Cenário 11: Buscar Usuário Inexistente
    [Tags]    negativo    medio
    [Documentation]    Testa que não é possível buscar um usuário inexistente (16 caracteres alfanuméricos)
    Buscar Usuário Inexistente    0000000000000000

Cenário 12: Deletar Usuário
    [Tags]    positivo    critico 
    [Documentation]    Testa a deleção do usuário criado no primeiro cenário
    Deletar Usuário    ${USER_ID}
Cenário 13: Atualizar Usuário Inexistente
    [Tags]    negativo    medio
    [Documentation]    Testa que não é possível atualizar um usuário inexistente (16 caracteres alfanuméricos) e cria novo usuário
    Atualizar Usuário com ID Inexistente    0000000000000000