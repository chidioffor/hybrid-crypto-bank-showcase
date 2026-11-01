/**
 * Public, offline illustration of route selection. It does not perform payment processing.
 */
export type Rail = "ACH" | "WIRE" | "SEPA" | "SWIFT" | "FASTER_PAYMENTS" | "CARD" | "MOBILE_MONEY" | "LOCAL_BANK_TRANSFER" | "INTERNAL_TRANSFER";

type PaymentIntent = {
  id: string;
  currency: "GBP" | "EUR" | "USD";
  preferredRail?: Rail;
  internalRecipient: boolean;
};

const supportedByCurrency: Record<PaymentIntent["currency"], Rail[]> = {
  GBP: ["FASTER_PAYMENTS", "WIRE", "CARD"],
  EUR: ["SEPA", "SWIFT", "CARD"],
  USD: ["ACH", "WIRE", "CARD"],
};

export function selectIllustrativeRoute(intent: PaymentIntent): Rail {
  if (intent.internalRecipient) return "INTERNAL_TRANSFER";
  const candidates = supportedByCurrency[intent.currency];
  if (intent.preferredRail && candidates.includes(intent.preferredRail)) return intent.preferredRail;
  return candidates[0];
}

const demo: PaymentIntent = { id: "demo-payment-001", currency: "EUR", preferredRail: "SEPA", internalRecipient: false };
console.log({ intentId: demo.id, illustrativeRoute: selectIllustrativeRoute(demo) });
