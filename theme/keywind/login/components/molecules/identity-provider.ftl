<#import "/assets/providers/providers.ftl" as providerIcons>

<#macro kw providers=[]>
  <div class="pt-4 separate text-secondary-600 dark:text-gray-400 text-sm">
    ${msg("identity-provider-login-label")}
  </div>
  <div class="gap-4 grid">
    <#list providers as provider>
      <a
        class="bg-secondary-100 dark:bg-gray-700 text-secondary-600 dark:text-gray-300 focus:ring-secondary-600 dark:focus:ring-gray-500 hover:bg-secondary-200 dark:hover:bg-gray-600 hover:text-secondary-900 dark:hover:text-white flex justify-center py-2 rounded-lg focus:outline-none focus:ring-2 focus:ring-offset-2 dark:focus:ring-offset-gray-800 px-4"
        data-provider="${provider.alias}"
        href="${provider.loginUrl}"
        type="button"
      >
        <#if providerIcons[provider.alias]??>
          <div class="h-6 w-6">
            <@providerIcons[provider.alias] />
          </div>
        <#else>
          ${provider.displayName!}
        </#if>
      </a>
    </#list>
  </div>
</#macro>
