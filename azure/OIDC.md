  # Upbound OpenID Connect (OIDC)

          Using Upbound OIDC to authenticate to Azure eliminates the need to store credentials in this control plane.

          You will need to:

          1. Create an **Azure Application** that will be used to authenticate `provider-azure`.
          2. Establish trust between your **Azure Application** and **Upbound** using a **Federated Credential**.
          3. Grant the necessary permissions to your **Application Service Principal** by assigning it a **Role**.
          4. Provide **Client ID**, **Tenant ID**, and **Subscription ID** of your **Azure Application**.

          ## Create an Application

          1. Sign in to [Azure portal](https://portal.azure.com/).
          2. Go to **Azure Active Directory**.
          3. Select **App registrations** in the left navigation.
          4. Click **+ New registration**.
          5. In the **Name** field enter `upbound-oidc-provider`.
          6. In the **Supported account types**> section select **Accounts in this organizational directory only**.
          7. In the **Redirect URI** section select **Web** and leave the **URL** field blank.
          8. Press **Register**.

          ## Create a Federated Credential

          When **Upbound** authenticates to **Azure** it provides an OIDC subject (`sub`) in the following format:
          ```
          mcp:<account>/<mcp-name>:provider:<provider-name>
          ```
          We will create a **Federated Credential** to establish trust between **Azure** and **Upbound**.

          1. Sign in to [Azure portal](https://portal.azure.com/).
          2. Go to **Azure Active Directory**.
          3. Select **App registrations** in the left navigation.
          4. Select your **Application** by searching for `upbound-oidc-provider`.
          5. Select **Certificates and secrets** in the left navigation.
          6. Select **Federated credentials** tab.
          7. Click **+ Add credential**.
          8. In **Federated credential scenario** select `Other Issuer`.
          9. Fill out **Connect your account** with the following:
                * **Issuer**: `https://proidc.upbound.io`.
                * **Subject identifier**: `mcp:<account>/<mcp-name>:provider:provider-azure`.
          10. Fill out **Credential details** with the following:
                * **Name**: `upbound-<account>-<mcp-name>-provider-azure`.
                * **Description**: `Upbound MCP <account>/<mcp-name> Provider Azure`.
                * **Audience**: leave unmodified with`api://AzureADTokenExchange`.
          11. Press **Add**.

          ## Assign a Role to the Application Service Principal

          1. Sign in to [Azure portal](https://portal.azure.com/).
          2. Go to **Subscriptions**.
          3. Select your subscription.
          4. Select **Access control (IAM)** in the left navigation.
          5. Click **+ Add** and select **Add role assignment**.
          6. Select **Privileged administrator roles** tab.
          7. Find and select the `Contributor` role.
          8. Press **Next**.
          9. In **Assign access to** select **User, group, or service principal**.
          10. Click **+ Select members**.
          11. Find your application by entering `upbound-oidc-provider` in the search field.
          12. Press **Select**.
          13. Press **Review + assign**.
          14. Make sure everything is correct and press **Review + assign** again.

          ## Find your Client ID, Tenant ID, and Subscription ID

          ### Find your Client ID, Tenant ID

          1. Sign in to [Azure portal](https://portal.azure.com/).
          2. Go to **Azure Active Directory**.
          3. Select **App registrations** in the left navigation.
          4. Select your **Application** by searching for `upbound-oidc-provider`.
          5. Select **Overview** in the left navigation.
          6. Copy **Application (client) ID** and paste it as **Client ID** in the **Upbound** UI.

          ### Find your Subscription ID

          1. Sign in to [Azure portal](https://portal.azure.com/).
          2. Go to **Subscriptions**.
          3. Select your subscription.
          4. Copy **Subscription ID** and paste it as **Subscription ID** in the **Upbound** UI.