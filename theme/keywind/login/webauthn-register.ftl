<#import "template.ftl" as layout>
<#import "components/atoms/button.ftl" as button>
<#import "components/atoms/button-group.ftl" as buttonGroup>
<#import "components/atoms/alert.ftl" as alert>

<@layout.registrationLayout script="dist/webAuthnRegister.js"; section>
  <#if section="title">
    title
  <#elseif section="header">
    ${kcSanitize(msg("webauthn-registration-title"))?no_esc}
  <#elseif section="form">
    <div x-data="webAuthnRegister">
      <form action="${url.loginAction}" method="post" x-ref="registerForm">
        <input name="attestationObject" type="hidden" x-ref="attestationObjectInput" />
        <input name="authenticatorLabel" type="hidden" x-ref="authenticatorLabelInput" />
        <input name="clientDataJSON" type="hidden" x-ref="clientDataJSONInput" />
        <input name="error" type="hidden" x-ref="errorInput" />
        <input name="publicKeyCredentialId" type="hidden" x-ref="publicKeyCredentialIdInput" />
        <input name="transports" type="hidden" x-ref="transportsInput" />
      </form>
      <p class="text-secondary-600 dark:text-gray-400 text-sm mb-6">
        Register your passkey or security key. You can use a passkey (built into your device) or a physical security key. Follow your browser's prompts to complete registration.
      </p>
      <@buttonGroup.kw>
        <@button.kw @click="registerSecurityKey" color="primary" type="submit">
          ${msg("doRegister")}
        </@button.kw>
        <#if !isSetRetry?has_content && isAppInitiatedAction?has_content>
          <form action="${url.loginAction}" method="post">
            <@button.kw color="secondary" name="cancel-aia" type="submit" value="true">
              ${msg("doCancel")}
            </@button.kw>
          </form>
        </#if>
      </@buttonGroup.kw>
    </div>
  </#if>
</@layout.registrationLayout>

<script>
  document.addEventListener('alpine:init', () => {
    Alpine.store('webAuthnRegister', {
      attestationConveyancePreference: '${(attestationConveyancePreference!"")?js_string}',
      authenticatorAttachment: '${(authenticatorAttachment!"")?js_string}',
      challenge: '${(challenge!"")?js_string}',
      createTimeout: '${(createTimeout!"")?js_string}',
      excludeCredentialIds: '${(excludeCredentialIds!"")?js_string}',
      requireResidentKey: '${(requireResidentKey!"")?js_string}',
      rpEntityName: '${(rpEntityName!"")?js_string}',
      rpId: '${(rpId!"")?js_string}',
      signatureAlgorithms: '${((signatureAlgorithms?is_sequence)?then((signatureAlgorithms?join(","))!"", (signatureAlgorithms!"")?string))!""?js_string}',
      unsupportedBrowserText: '${msg("webauthn-unsupported-browser-text")?js_string}',
      userId: '${(userid!"")?js_string}',
      userVerificationRequirement: '${(userVerificationRequirement!"")?js_string}',
      username: '${(username!"")?js_string}',
    })
  })
</script>
