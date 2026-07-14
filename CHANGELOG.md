# Release Notes for Unzer Payment Plugin for OXID eShop 6

## [1.0.8]

- Updated Order Status Logic for Direct Bank Transfer

## [1.0.7]
- Fixed an issue in the OXID webhook handler where incorrect shop scoping caused the wrong order ID to be resolved from a transaction ID, leading to orders not being completed or visible.

## [1.0.6]
- Added Customization designer in backend module configuration

## [1.0.5]
- Updated iDEAL Payment naming and logo
- Fix for direct debit paypage creation

## [1.0.4]

- Added Unzer Order ID to enable cross platform search

## [1.0.3]

- Fixed transaction type for Wero

## [1.0.2]

- Optimization saving settings in backend

## [1.0.1]

- iDEAL Payment Logo Update

## [1.0.0]

We are excited to announce the release of the new Unzer Payment plugin for OXID eShop 6.

Before you install this plugin please through the notes below:

This is a completely new plugin based Unzer Payment Pages, where the old OXID 6 plugin was based on Unzer UI Components. Therefore you must read https://docs.unzer.com/plugins/oxid-6/oxid-6-migrate-ui-pp/ before you install the new plugin.

### 🔑 Key Features:

- **Integration with PayPage V2:** The plugin is integrated with Unzer’s PayPage V2 for an enhanced payment experience.
- **Plugin Implementation:** This version has been implemented as a standalone plugin, providing more flexibility and ease of maintenance, rather than being an integrated component.
- **Centralized Keypair Configuration:** The plugin supports configuration with a single master keypair, simplifying the setup. All payment methods, including Unzer PayLater, can be managed through this single keypair.

### 🔁 Migration Instructions:

1. **Obtain New Master Keypair:** Request a new master keypair that encompasses all desired payment methods.  
   **Install and Configure New Plugin:** Install the new Unzer Payment plugin and configure it using the new master keypair.

2. **Deactivate Payment Methods:** Disable all payment methods associated with the old plugin in the backend to prevent them from appearing in the checkout.

3. **Maintain Configuration of Old Plugin:** Keep the old plugin active with its current configuration. This will allow you to view, refund, and cancel any previous transactions.

4. **Activate New Payment Methods:** Once configured, activate the payment methods through the new plugin so they are visible during checkout.

5. **Support**  
   For any issues or further assistance with the new plugin, please contact our support team at: [support@unzer.com](mailto:support@unzer.com)

> By following these steps, you will be able to transition seamlessly to the new plugin while retaining the ability to manage existing transactions.

We hope you enjoy the enhancements brought by the new Unzer Payment plugin!

### 💳 Supported Payment Methods:

- AliPay
- Apple Pay
- Bancontact
- Cards and Click to Pay (CTP)
- Direct Bank Transfer
- Direct Debit Secured
- EPS
- Google Pay
- iDEAL
- Klarna
- PayPal
- PayU
- Post Finance eFinance
- Prepayment
- Przelewy24
- SEPA Direct Debit
- TWINT
- Unzer Installment
- Unzer Invoice
- WeChat Pay
- Wero

