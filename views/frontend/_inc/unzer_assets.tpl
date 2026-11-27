<script type="module" src="https://static-v2.unzer.com/v2/ui-components/index.js"></script>

<div id="unzer-container"></div>

<script>
    var unzerRedirectUrl = '[{$unzerRedirectUrl}]';
    var unzerErrorRedirectUrl = '[{$unzerErrorRedirectUrl}]';
    var unzerClickToPay = '[{$unzerClickToPay}]';

    Promise.all([
        customElements.whenDefined("unzer-payment"),
        customElements.whenDefined("unzer-pay-page"),
    ]).then(() => {
        const btnCheckout = document.getElementById("unzer-checkout-btn");
        btnCheckout.addEventListener("click", showCheckout);
        [{if $unzerOpenPreparedPage}]
        showCheckout();
        [{/if}]
    });

    function showCheckout() {
        [{if $unzerPreCreateOrder && !$unzerOpenPreparedPage}]
        const button = document.getElementById("unzer-checkout-btn");
        const form = button.form || button.closest("form");
        if (!form || !form.reportValidity()) { return; }
        const fnc = form.querySelector('input[name="fnc"]');
        if (!fnc) { return; }
        fnc.value = 'unzerPrepareOrder';
        button.disabled = true;
        form.submit();
        return;
        [{/if}]
        const unzerContainer = document.getElementById("unzer-container");
        unzerContainer.innerHTML = `
            <unzer-payment publicKey="[{$unzerPubKey}]" locale="[{$unzerLocale}]">
                <unzer-pay-page
                    id="checkout"
                    payPageId="[{$unzerPaypageToken}]"
                    [{$unzerClickToPay}]
                ></unzer-pay-page>
            </unzer-payment>
        `;

        const checkout = document.getElementById("checkout");

        checkout.abort(function () {
            return;
        });

        checkout.success(function (data) {
            window.location.href = unzerRedirectUrl;
        });

        checkout.error(function (error) {
            window.location.href = unzerErrorRedirectUrl;
        });

        checkout.open();
    }
</script>
