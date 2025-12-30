<#import "components/atoms/button.ftl" as button>

<#macro conditionalUIData>
    <#if enableWebAuthnConditionalUI?has_content>
        <form id="webauth" action="${url.loginAction}" method="post">
            <input type="hidden" id="clientDataJSON" name="clientDataJSON"/>
            <input type="hidden" id="authenticatorData" name="authenticatorData"/>
            <input type="hidden" id="signature" name="signature"/>
            <input type="hidden" id="credentialId" name="credentialId"/>
            <input type="hidden" id="userHandle" name="userHandle"/>
            <input type="hidden" id="error" name="error"/>
        </form>
        <#if authenticators??>
            <form id="authn_select" class="hidden">
                <#list authenticators.authenticators as authenticator>
                    <input type="hidden" name="authn_use_chk" value="${authenticator.credentialId}"/>
                </#list>
            </form>
        </#if>
        <script type="module">
           <#outputformat "JavaScript">
           import { authenticateByWebAuthn } from "${url.resourcesPath}/dist/webAuthnAuthenticate.js";
           import { initAuthenticate } from "${url.resourcesPath}/dist/passkeysConditionalAuth.js";

           const args = {
               isUserIdentified : ${isUserIdentified},
               challenge : ${challenge?c},
               userVerification : ${userVerification?c},
               rpId : ${rpId?c},
               createTimeout : ${createTimeout?c}
           };

           document.addEventListener("DOMContentLoaded", (event) => initAuthenticate({errmsg : ${msg("passkey-unsupported-browser-text")?c}, ...args}));
           const authButton = document.getElementById('authenticateWebAuthnButton');
           if (authButton) {
               authButton.addEventListener("click", (event) => {
                   event.preventDefault();
                   authenticateByWebAuthn({errmsg : ${msg("webauthn-unsupported-browser-text")?c}, ...args});
               }, { once: true });
           }
           </#outputformat>
        </script>
        <div class="mt-4">
          <a href="#" id="authenticateWebAuthnButton" class="mt-4 flex justify-center relative rounded-lg w-full focus:outline-none focus:ring-2 focus:ring-offset-2 dark:focus:ring-offset-gray-800 bg-secondary-100 dark:bg-gray-700 text-secondary-600 dark:text-gray-300 focus:ring-secondary-600 dark:focus:ring-gray-500 hover:bg-secondary-200 dark:hover:bg-gray-600 hover:text-secondary-900 dark:hover:text-white px-4 py-2 text-sm">
            ${msg("webauthn-doAuthenticate")}
          </a>
        </div>
    </#if>
</#macro>

