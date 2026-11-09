# Hybrid Crypto Bank — public engineering showcase

> A safe, representative demonstration of financial-platform orchestration—not the Hybrid Crypto Bank production source code.

Hybrid Crypto Bank is represented as a systems-design case study for a multi-rail financial product. The focus here is how to keep provider capabilities, routing choices, customer intent, and auditable outcomes clearly separated.

> **Confidentiality notice:** This repository is an independently authored, public-safe reference to selected architecture and security responsibilities represented by the private Hybrid Crypto Bank work. It does not contain client source, deployment data, credentials, or production configuration, which remain protected under confidentiality obligations.

## What this showcase demonstrates

- **Provider abstraction:** a stable internal intent model avoids coupling product flows to any one provider.
- **Deliberate routing:** rail selection is policy-driven and explainable, rather than hard-wired into a user interface.
- **Lifecycle discipline:** an instruction moves through explicit states, supporting retries and auditability.
- **Honest integration boundaries:** a rail can be represented in the routing layer without asserting that it is enabled in production.

## Payment rails represented

ACH · Wire · SEPA · SWIFT · Faster Payments · Card · Mobile money · Local bank transfer · Internal transfer

These are **integration paths represented by the design**, not a claim that every rail is production-enabled or available in every market. The underlying private project includes implemented Stripe Treasury connected-account and onboarding work; this public repository contains no provider credentials, calls, or configuration.

## Technology lens

| Area | Representative tools |
| --- | --- |
| Modular services | Node.js, JavaScript, TypeScript |
| Platform domains | gateway, users, wallets, payments, cards, escrow |
| Delivery | Docker, API-first service boundaries |
| Integration design | provider adapters, routing policies, auditable events |

## Safe sample code

[`src/routePayment.ts`](src/routePayment.ts) uses invented payment instructions and a tiny, offline routing policy. It does not call a banking provider, move value, collect credentials, or model a real compliance process.

```bash
npm run demo
```

## Architecture

See [the public-safe architecture notes](docs/architecture.md) for a conceptual diagram and the safety boundaries used for this showcase.

For a limited contract-lifecycle and confidential-allocation reference, see [contract and settlement controls](docs/contract-and-confidential-settlement-reference.md). The Solidity examples in [`examples/`](examples/) are newly authored illustrations; they are not deployed contracts or copies of private code.

## Boundaries

This repository intentionally excludes proprietary source, provider integrations, credentials, customer data, account data, transaction records, compliance rules, deployment topology, secrets, and production configuration. It is not a bank, payment service, or offer of financial services.

© Chidiebere Offor. Demonstration material; no licence to use the Hybrid Crypto Bank name or underlying private implementation is granted.
