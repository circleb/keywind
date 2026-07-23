<#import "template.ftl" as layout>
<#import "components/atoms/button.ftl" as button>
<#import "components/atoms/button-group.ftl" as buttonGroup>
<#import "components/atoms/checkbox.ftl" as checkbox>
<#import "components/atoms/form.ftl" as form>
<#import "components/atoms/input.ftl" as input>
<#import "components/atoms/link.ftl" as link>
<#import "components/molecules/identity-provider.ftl" as identityProvider>
<#import "features/labels/username.ftl" as usernameLabel>
<#import "passkeys.ftl" as passkeys>

<#assign usernameLabel><@usernameLabel.kw /></#assign>

<@layout.registrationLayout
  displayInfo=realm.password && realm.registrationAllowed && !registrationDisabled??
  displayMessage=!messagesPerField.existsError("username", "password")
  ;
  section
>
  <#if section="header">
    ${msg("loginAccountTitle")} <br /> <div class="text-sm text-secondary-600 dark:text-gray-400">(not the same as Heritage Press)</div>
  <#elseif section="form">
    <#if realm.password>
      <div x-data="{ showPassword: false }">
        <div x-show="!showPassword">
          <@buttonGroup.kw>
            <button
              class="bg-secondary-100 dark:bg-secondary-500 text-secondary-600 dark:text-gray-300 focus:ring-secondary-600 dark:focus:ring-gray-500 hover:bg-secondary-200 dark:hover:bg-gray-600 hover:text-secondary-900 dark:hover:text-white px-4 py-2 text-sm flex justify-center relative rounded-lg w-full focus:outline-none focus:ring-2 focus:ring-offset-2 dark:focus:ring-offset-gray-800"
              type="button"
              @click="showPassword = true"
            >
              Login With Password
            </button>
          </@buttonGroup.kw>
        </div>
        <div x-show="showPassword" x-cloak>
          <@form.kw
            action=url.loginAction
            method="post"
            onsubmit="login.disabled = true; return true;"
          >
            <input
              name="credentialId"
              type="hidden"
              value="<#if auth.selectedCredential?has_content>${auth.selectedCredential}</#if>"
            >
            <@input.kw
              autocomplete=realm.loginWithEmailAllowed?string("email", "username")
              autofocus=true
              disabled=usernameEditDisabled??
              invalid=messagesPerField.existsError("username", "password")
              label=usernameLabel
              message=kcSanitize(messagesPerField.getFirstError("username", "password"))
              name="username"
              type="text"
              value=(login.username)!''
            />
            <@input.kw
              invalid=messagesPerField.existsError("username", "password")
              label=msg("password")
              name="password"
              type="password"
            />
            <#if realm.rememberMe && !usernameEditDisabled?? || realm.resetPasswordAllowed>
              <div class="flex items-center justify-between">
                <#if realm.rememberMe && !usernameEditDisabled??>
                  <@checkbox.kw
                    checked=login.rememberMe??
                    label=msg("rememberMe")
                    name="rememberMe"
                  />
                </#if>
                <#if realm.resetPasswordAllowed>
                  <@link.kw color="primary" href=url.loginResetCredentialsUrl size="small">
                    ${msg("doForgotPassword")}
                  </@link.kw>
                </#if>
              </div>
            </#if>
            <@buttonGroup.kw>
              <@button.kw color="primary" name="login" type="submit">
                ${msg("doLogIn")}
              </@button.kw>
            </@buttonGroup.kw>
          </@form.kw>
        </div>
      </div>
      <#-- <@passkeys.conditionalUIData /> -->
    </#if>
  <#elseif section="socialProviders">
    <#if realm.password && social.providers??>
      <@identityProvider.kw providers=social.providers />
    </#if>
  </#if>
</@layout.registrationLayout>
<div class="text-center mt-4 text-sm text-secondary-600 dark:text-gray-400">
  ${msg("noAccount")}
  <@link.kw color="primary" href="https://my.homesteadheritage.org/register">
    ${msg("doRegister")}
  </@link.kw>
</div>
<div class="text-center">
  <span class="text-sm text-secondary-600 dark:text-gray-400">Having trouble?</span>
  <@link.kw color="primary" size="small" href="https://my.homesteadheritage.org/account/troubleshooting">
    Visit our troubleshooting page
  </@link.kw>
</div>