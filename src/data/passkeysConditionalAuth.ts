import { base64url } from 'rfc4648';
import { returnSuccess, signal, AuthenticateInput } from './webAuthnAuthenticate.js';

export interface PasskeysConditionalAuthInput extends AuthenticateInput {
  errmsg: string;
}

export function initAuthenticate(input: PasskeysConditionalAuthInput, availableCallback: (available: boolean) => void = () => {}): void {
  // Check if WebAuthn is supported by this browser
  if (!window.PublicKeyCredential) {
    // Fail silently as WebAuthn Conditional UI is not required
    return;
  }
  
  if (input.isUserIdentified || typeof PublicKeyCredential.isConditionalMediationAvailable === 'undefined') {
    availableCallback(false);
  } else {
    tryAutoFillUI(input, availableCallback);
  }
}

async function doAuthenticate(input: PasskeysConditionalAuthInput): Promise<PublicKeyCredential> {
  // Check if WebAuthn is supported by this browser
  if (!window.PublicKeyCredential) {
    // Fail silently as WebAuthn Conditional UI is not required
    throw new Error('WebAuthn not supported');
  }

  const publicKey: PublicKeyCredentialRequestOptions = {
    rpId: input.rpId,
    challenge: new Uint8Array(base64url.parse(input.challenge, { loose: true })),
  };

  publicKey.allowCredentials = !input.isUserIdentified ? [] : getAllowCredentials();

  if (input.createTimeout !== 0) {
    publicKey.timeout = input.createTimeout * 1000;
  }

  if (input.userVerification !== 'not specified') {
    publicKey.userVerification = input.userVerification as UserVerificationRequirement;
  }

  return navigator.credentials.get({
    publicKey: publicKey,
    signal: signal(),
    ...input.additionalOptions,
  }) as Promise<PublicKeyCredential>;
}

async function tryAutoFillUI(input: PasskeysConditionalAuthInput, availableCallback: (available: boolean) => void = () => {}): Promise<void> {
  const isConditionalMediationAvailable = await PublicKeyCredential.isConditionalMediationAvailable();
  if (isConditionalMediationAvailable) {
    availableCallback(true);
    input.additionalOptions = { mediation: 'conditional' };
    try {
      const result = await doAuthenticate(input);
      returnSuccess(result);
    } catch {
      // Fail silently as WebAuthn Conditional UI is not required
    }
  } else {
    availableCallback(false);
  }
}

function getAllowCredentials(): PublicKeyCredentialDescriptor[] {
  const allowCredentials: PublicKeyCredentialDescriptor[] = [];
  const authnSelectForm = document.forms.namedItem('authn_select') as HTMLFormElement | null;
  
  if (authnSelectForm) {
    const authnUse = authnSelectForm.elements.namedItem('authn_use_chk') as HTMLInputElement | RadioNodeList | null;
    if (authnUse !== null && authnUse !== undefined) {
      if (authnUse instanceof HTMLInputElement) {
        allowCredentials.push({
          id: new Uint8Array(base64url.parse(authnUse.value, { loose: true })),
          type: 'public-key',
        });
      } else if (authnUse.length !== undefined) {
        // RadioNodeList
        for (let i = 0; i < authnUse.length; i++) {
          const entry = authnUse[i] as HTMLInputElement;
          allowCredentials.push({
            id: new Uint8Array(base64url.parse(entry.value, { loose: true })),
            type: 'public-key',
          });
        }
      }
    }
  }
  
  return allowCredentials;
}

