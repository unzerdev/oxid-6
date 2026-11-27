<script type="module" src="https://static-v2.unzer.com/v2/ui-components/index.js"></script>
<style>
    .unzer-paypal-express-container, .unzer-google-pay-express-container, .unzer-applepay-express-container {
        margin-bottom: 5px;
    }
    .unzer_cart_express_area,
    .unzer_mini_express_area,
    .unzer_modal_express_area {
        clear: both;
    }
    .cl-basket .unzer_cart_express_area {
        padding-top: 10px;
    }
    #unzer-express-buttons-container > .unzer-express-buttons-error {
        margin: 0 0 10px;
    }
</style>
<script>
    window.unzer_parameters = [{$oViewConf->getUnzerJSParams()}];
    const ExpressButtons = {
        interval: null,
        intervalCounter: 0,
        cartTotal: null,
        applePaySession: null,
        attemptToPlaceButton: function () {

            let container = document.querySelector( '.unzer_cart_express_area' );
            if ( ! container ) {
                container = document.querySelector( '.unzer_mini_express_area');
            }
            if ( ! container ) {
                return false;
            }
            if (document.getElementById( 'unzer-express-buttons-container' )) {
                return false;
            }

            const button_container = document.createElement( 'div' );
            button_container.id    = 'unzer-express-buttons-container';

            const unzer_express_error_container = document.createElement('div');
            unzer_express_error_container.classList.add('unzer-express-buttons-error');
            unzer_express_error_container.classList.add('oxid-error');
            unzer_express_error_container.classList.add('alert');
            unzer_express_error_container.classList.add('alert-danger');
            unzer_express_error_container.hidden = true;
            unzer_express_error_container.innerHTML = unzer_parameters.generic_error_message_express;
            button_container.appendChild(unzer_express_error_container);

            const unzer_payment_container = document.createElement( 'unzer-payment' );
            unzer_payment_container.classList.add('unzer-express-payment');
            unzer_payment_container.setAttribute('publicKey', unzer_parameters.publicKey);
            unzer_payment_container.setAttribute('locale', unzer_parameters.locale);

            if (unzer_parameters.express.paypal) {
                const unzer_paypal_express_container = document.createElement('div');
                unzer_paypal_express_container.classList.add('unzer-paypal-express-container');
                const unzer_paypal_express_element = document.createElement('unzer-paypal-express');
                unzer_paypal_express_element.classList.add('unzer-paypal-express');
                unzer_paypal_express_container.appendChild(unzer_paypal_express_element);
                unzer_payment_container.appendChild(unzer_paypal_express_container);
            }

            if (unzer_parameters.express.googlepay) {
                const unzer_google_pay_express_container = document.createElement('div');
                unzer_google_pay_express_container.classList.add('unzer-google-pay-express-container');
                const unzer_google_pay_express_element = document.createElement('unzer-google-pay');
                unzer_google_pay_express_element.classList.add('unzer-google-pay');
                unzer_google_pay_express_container.appendChild(unzer_google_pay_express_element);
                unzer_payment_container.appendChild(unzer_google_pay_express_container);
            }

            if (unzer_parameters.express.applepay) {
                const unzer_applepay_express_container = document.createElement('div');
                unzer_applepay_express_container.classList.add('unzer-applepay-express-container');
                unzer_payment_container.appendChild(unzer_applepay_express_container);
            }

            button_container.appendChild(unzer_payment_container);

            container.appendChild( button_container );
            return unzer_payment_container;
        },

        getTotals: async function() {
            const cartTotal = await getOxidCartAmount();

            if (!cartTotal) {
                console.warn('Warenkorb-Betrag konnte nicht ermittelt werden.');
                return null;
            }

            ExpressButtons.cartTotal = cartTotal;
            return cartTotal;
        },

        init: async function () {
            if (!unzer_parameters.express.paypal && !unzer_parameters.express.googlepay && !unzer_parameters.express.applepay) {
                return false;
            }
            if (unzer_parameters.express.is_express) {
                return false;
            }

            const cartTotal = await this.getTotals();

            if (!cartTotal || !cartTotal.amount) {
                console.log('No cartTotal');
                return false;
            }
            const unzerExpressPayment = this.attemptToPlaceButton();
            if (!unzerExpressPayment) {
                console.log('Not able to place buttons');
                return false;
            }
            await Promise.all([
                customElements.whenDefined('unzer-payment'),
                unzer_parameters.express.googlepay && customElements.whenDefined('unzer-google-pay'),
                unzer_parameters.express.paypal && customElements.whenDefined('unzer-paypal-express'),
                unzer_parameters.express.applepay && customElements.whenDefined('unzer-apple-pay'),
            ]).then(() => {
                if (!unzerExpressPayment.isConnected) {
                    return;
                }
                const unzerPaypalExpress = unzerExpressPayment.querySelector('.unzer-paypal-express');
                const unzerGooglePay = unzerExpressPayment.querySelector('.unzer-google-pay');
                const appleContainer = unzerExpressPayment.querySelector('.unzer-applepay-express-container');

                if (unzerPaypalExpress) {
                    this.registerPaypalExpress(
                        unzerPaypalExpress,
                        unzerExpressPayment
                    );
                }

                if (unzerGooglePay) {
                    this.registerGooglePay(unzerGooglePay, unzerExpressPayment);
                    const container = unzerGooglePay.parentNode;
                    unzerGooglePay.remove();
                    container.appendChild(unzerGooglePay);
                }

                if (appleContainer) {
                    this.registerApplePay(unzerExpressPayment);
                    const button = document.createElement('unzer-apple-pay');
                    button.classList.add('unzer-apple-pay');
                    appleContainer.appendChild(button);
                }
            });
            return true;
        },

        refresh: async function() {

            if (this.refreshing) {
                this.refreshPending = true;
                return;
            }

            this.refreshing = true;

            try {
                do {
                    this.refreshPending = false;

                    if (this.applePaySession) {
                        try {
                            this.applePaySession.abort();
                        } catch (error) {
                            if (!['InvalidAccessError', 'InvalidStateError'].includes(error.name)) {
                                throw error;
                            }
                        } finally {
                            this.applePaySession = null;
                        }
                    }
                    document.getElementById(
                        'unzer-express-buttons-container'
                    )?.remove();

                    await this.init();

                } while (this.refreshPending);

            } finally {
                this.refreshing = false;
            }
        },

        showError: function() {
            const errorElement = document.querySelector(
                '.unzer-express-buttons-error'
            );
            if (errorElement) {
                errorElement.removeAttribute('hidden');
            }
        },

        registerPaypalExpress: function (paypalButton, unzerExpressPayment) {
            paypalButton.id =
                'unzer-paypal-button-' + Math.floor(Math.random() * 10000);
            paypalButton.addEventListener('click', async (event) => {
                event.stopPropagation();
                const response = await unzerExpressPayment.submit();

                if (!response?.submitResponse?.success) {
                    this.showError();
                    return;
                }
                const paymentTypeId = response.submitResponse.data.id;
                fetch(unzer_parameters.urls.paypal, {
                    method: 'POST',
                    headers: {
                        'Content-Type': 'application/json',
                    },
                    body: JSON.stringify({
                        stoken: unzer_parameters.stoken,
                        paymentTypeId: paymentTypeId,
                    }),
                })
                    .then((response) => response.json())
                    .then((json) => {
                        if (!json.redirectUrl) throw new Error('Express checkout failed');
                        location.href = json.redirectUrl;
                    })
                    .catch(() => {
                        this.showError();
                    });
            });
        },

        registerGooglePay: function(googlePayButton, unzerExpressPayment) {
            const googlePayData = {
                gatewayMerchantId: unzer_parameters.google_pay_options.gatewayMerchantId,
                merchantInfo: unzer_parameters.google_pay_options.merchantInfo,
                transactionInfo: {
                    currencyCode: unzer_parameters.currency,
                    countryCode: unzer_parameters.google_pay_options.countryCode,
                    totalPriceStatus: 'ESTIMATED',
                    checkoutOption: 'DEFAULT',
                    totalPrice: String(ExpressButtons.cartTotal.amount),
                },
                buttonOptions: unzer_parameters.google_pay_options.buttonOptions,
                allowedCardNetworks: unzer_parameters.google_pay_options.allowedCardNetworks,
                allowCreditCards: unzer_parameters.google_pay_options.allowCreditCards,
                allowPrepaidCards: unzer_parameters.google_pay_options.allowPrepaidCards,
                billingAddressParameters: { format: 'MIN' },
                billingAddressRequired: true,
                emailRequired: true,
                onPaymentDataChangedCallback: () => {
                    return {};
                },
                shippingOptionParameters: {},
                onPaymentAuthorizedCallback: async (
                    paymentData,
                    approve,
                    reject
                ) => {
                    const response = await unzerExpressPayment.submit();
                    if (!response?.submitResponse?.success) {
                        this.showError();
                        return;
                    }
                    const paymentTypeId = response.submitResponse.data.id;

                    fetch(unzer_parameters.urls.googlePay, {
                        method: 'POST',
                        headers: {
                            'Content-Type': 'application/json',
                        },
                        body: JSON.stringify({
                            stoken: unzer_parameters.stoken,
                            paymentTypeId,
                            paymentData,
                        }),
                    })
                        .then((response) => response.json())
                        .then((json) => {
                            if (!json.redirectUrl) throw new Error('Express checkout failed');
                            location.href = json.redirectUrl;
                        })
                        .catch(() => {
                            this.showError();
                        });
                },
                shippingAddressRequired: true,
                shippingOptionRequired: false,
            };
            unzerExpressPayment.setGooglePayData(googlePayData);
        },

        registerApplePay: function(unzerExpressPayment) {
            console.log('register amount', ExpressButtons.cartTotal.amount);
            const applePayPaymentRequest = {
                countryCode: unzer_parameters.applepay_options.countryCode,
                currencyCode: unzer_parameters.currency,
                supportedNetworks: unzer_parameters.applepay_options.supportedNetworks,
                merchantCapabilities: unzer_parameters.applepay_options.merchantCapabilities,
                total: {
                    label: unzer_parameters.applepay_options.shopName,
                    amount: String(ExpressButtons.cartTotal.amount),
                },
                requiredShippingContactFields: [
                    'postalAddress',
                    'name',
                    'email',
                    'phone',
                ],
                requiredBillingContactFields: [
                    'postalAddress',
                    'name',
                    'email',
                    'phone',
                ],

                onPaymentAuthorizedCallback: async (
                    paymentData,
                    approve,
                    reject,
                    event
                ) => {
                    let shippingContact = event.payment.shippingContact;
                    let billingContact = event.payment.billingContact;

                    // You can create customer here based on paymentData
                    const response = await unzerExpressPayment.submit();
                    if (response.submitResponse.success) {
                        approve();
                    } else {
                        reject();
                        this.showError();
                        return;
                    }
                    const paymentTypeId = response.submitResponse.data.id;

                    fetch(unzer_parameters.urls.applePay, {
                        method: 'POST',
                        headers: {
                            'Content-Type': 'application/json',
                        },
                        body: JSON.stringify({
                            stoken: unzer_parameters.stoken,
                            paymentTypeId,
                            paymentData,
                            shippingContact,
                            billingContact,
                        }),
                    })
                        .then((response) => response.json())
                        .then((json) => {
                            if (!json.redirectUrl) throw new Error('Express checkout failed');
                            location.href = json.redirectUrl;
                        })
                        .catch(() => {
                            this.showError();
                        });
                },
            };
            applePayPaymentRequest.initApplePaySession = (applePaySession) => {
                this.applePaySession = applePaySession;
            };
            unzerExpressPayment?.setApplePayData(applePayPaymentRequest);
        }
    }

    ExpressButtons.init();
    new MutationObserver((changes) => {
        const selector = '.unzer_mini_express_area, .unzer_cart_express_area';
        if (changes.some(change => Array.from(change.addedNodes).some(node =>
            node.nodeType === 1 && (node.matches(selector) || node.querySelector(selector))))) {
            ExpressButtons.refresh();
        }
    }).observe(document.body, { childList: true, subtree: true });

    async function getOxidCartAmount() {

        const area = document.querySelector('.unzer_cart_express_area') || document.querySelector('.unzer_mini_express_area');
        return area ? { amount: Number(area.dataset.amount), currency: unzer_parameters.currency } : null;
    }

    /*
     * OXID 7 – Unzer Express
     * Warenkorb-AJAX-Refresh
     */

    window.addEventListener('basketLoaded', async function () {

        if (document.body.classList.contains('cl-basket') &&
            unzer_parameters.express.applepay &&
            typeof window.ApplePaySession !== 'undefined') {
            window.location.replace(unzer_parameters.urls.basket);
            return;
        }

        await ExpressButtons.refresh();

        console.log('[Unzer] Express Buttons refreshed after basket update');

    });


</script>