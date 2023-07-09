# Aplicativo Angular implantando em uma VM no Azure com CI/CD.

Este repositório contém um aplicativo básico gerado pelo Angular CLI que está configurado para ser implantado automaticamente no Azure utilizando o Terraform e GitHub Actions.

## Sobre o Projeto

O projeto utiliza o GitHub Actions para implementar um pipeline de CI/CD (Integração Contínua/Entrega Contínua). Com um push para o branch `master`, o GitHub Actions inicia uma série de etapas que incluem a compilação do aplicativo Angular, execução de testes e, finalmente, a implantação do aplicativo no Azure usando o Terraform.

## Requisitos

Para usar este repositório e implantar o aplicativo no Azure, você precisará do seguinte:

1. Conta do GitHub
2. Conta do Azure
3. Terraform (versão 1.4 ou superior)
4. Azure CLI (para configuração inicial)

## Configuração Inicial

Para configurar o projeto para sua conta do Azure, você precisa criar um novo Service Principal e dar a ele as permissões corretas. Aqui estão as etapas que você deve seguir:

1. Abra o Azure CLI e crie um novo Service Principal com o seguinte comando:

    ```bash
    az ad sp create-for-rbac --name "<nome>" --role Contributor --scopes /subscriptions/<sub> --sdk-auth
    ```

    Neste comando, substitua `<nome>` pelo nome que você deseja dar ao seu Service Principal, e `<sub>` pela ID de sua assinatura do Azure.

    Este comando retorna um JSON com as credenciais do Service Principal. Guarde este JSON em um local seguro, pois você precisará dele para a próxima etapa.

2. No Azure CLI, crie um novo Resource Group e uma Storage Account usando os seguintes comandos:

    ```bash
    az group create --name <nome_resource_group> --location eastus
    az storage account create --name <nome_storage_account> --resource-group <nome_resource_group> --location eastus --sku Standard_LRS
    az storage container create --name tfstate --account-name <nome_storage_account>
    ```

    Substitua `<nome_resource_group>` pelo nome que você deseja para o seu Resource Group e `<nome_storage_account>` pelo nome que você deseja para a sua Storage Account.

3. No GitHub, navegue até o seu repositório e clique na guia "Settings". Em seguida, clique em "Secrets" na barra lateral.

4. Clique em "New repository secret" e crie um novo segredo chamado `AZURE_CREDENTIALS`. Cole o JSON das credenciais do Service Principal como o valor deste segredo.

5. Adicione outros segredos necessários no GitHub Secrets, como `AZURE_VM_USERNAME` e `AZURE_VM_PASSWORD`.

## Processo de Implantação

A implantação é ativada com um push para o branch `master`. O GitHub Actions executa o processo de compilação, teste e implantação do aplicativo no Azure.

## Arquitetura

O aplicativo é implantado no Azure como uma VM. Os recursos do Azure são provisionados e gerenciados pelo Terraform. Esta abordagem de infraestrutura como código permite uma rastreabilidade clara e reprodutibilidade dos ambientes de implantação.

## Segurança

Por favor, trate todos os segredos e chaves com cuidado e nunca os exponha publicamente. Caso suspeite que suas chaves foram comprometidas, revogue-as imediatamente seguindo as práticas recomendadas de segurança.

Por fim, este é um aplicativo de exemplo e pode não seguir todas as práticas recomendadas para ambientes de produção, como otimizações de desempenho, uso de CDNs, etc. Fique à vontade para contribuir e melhorar este projeto conforme necessário.
