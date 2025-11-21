[{include file="headitem.tpl" title=$oxmultilang.GENERAL_ADMIN_TITLE}]

<script type="text/javascript">
    window.onload = function () {
        top.oxid.admin.updateList('[{$sOxid}]');
    };
</script>

<style>

    .unzer_table {
        text-align: left;
    }
    .unzer_table th, .unzer_table td {
        padding: 2px;
    }
    .messagebox_warning {
        border-color: red;
        background: #fdd;
        color: red;
    }

    .btn-capture {
        margin: 0;
        background-color: #3b82f6; /* helles Blau */
        color: white;
        padding: 5px 9px;
        font-size: 12px;
        font-weight: 500;
        border: none;
        border-radius: 6px;
        cursor: pointer;
        transition: background-color 0.2s ease-in-out, box-shadow 0.2s;
    }

    .btn-capture:hover {
        background-color: #2563eb; /* etwas dunkleres Blau */
        box-shadow: 0 2px 6px rgba(59, 130, 246, 0.3);
    }

    .btn-capture:disabled {
        background-color: #a5c9ff;
        cursor: not-allowed;
        opacity: 0.7;
    }

    .btn-refund, .btn-cancel {
        margin: 0;
        background-color: #ef4444; /* r�tlich */
        color: white;
        padding: 5px 9px;
        font-size: 12px;
        font-weight: 500;
        border: none;
        border-radius: 6px;
        cursor: pointer;
        transition: background-color 0.2s ease-in-out, box-shadow 0.2s;
    }

    .btn-refund:hover, .btn-cancel:hover {
        background-color: #dc2626; /* etwas dunkleres Rot */
        box-shadow: 0 2px 6px rgba(239, 68, 68, 0.3);
    }

    .btn-refund:disabled, .btn-cancel:disabled {
        background-color: #fca5a5;
        cursor: not-allowed;
        opacity: 0.7;
    }

    .unzer_table_transactions {
        width: auto;
        border-collapse: collapse;
        color: #333;
        background-color: #fff;
    }

    .unzer_table_transactions thead {
        background-color: #f5f5f5;
    }

    .unzer_table_transactions th,
    .unzer_table_transactions td {
        padding: 12px 16px;
        border: 1px solid #ddd;
        text-align: left;
        vertical-align: middle;
    }

    .unzer_table_transactions th {
        font-weight: bold;
        background-color: #f0f0f0;
        color: #222;
        white-space: nowrap;
    }

    .unzer_table_transactions tr:nth-child(even) {
        background-color: #fafafa;
    }

    .unzer_table_transactions tr:hover {
        background-color: #f1f7ff;
    }

    .unzer_table_transactions td {
        white-space: nowrap;
        overflow: hidden;
        text-overflow: ellipsis;
        max-width: 450px;
    }
    input[type="number"] {
        padding: 8px 12px;
        border: 1px solid #ccc;
        border-radius: 6px;
        background-color: #fff;
        color: #333;
        width: 100px;
        box-sizing: border-box;
        transition: border-color 0.2s ease-in-out, box-shadow 0.2s ease-in-out;
    }

    input[type="number"]:focus {
        outline: none;
        border-color: #3b82f6;
        box-shadow: 0 0 0 3px rgba(59, 130, 246, 0.2);
    }

    input[type="number"]:disabled {
        background-color: #f5f5f5;
        color: #999;
        cursor: not-allowed;
    }

</style>

<form name="transfer" id="transfer" action="[{$oViewConf->getSelfLink()}]" method="post">
    [{$oViewConf->getHiddenSid()}]
    <input type="hidden" name="oxid" value="[{$oxid}]">
    <input type="hidden" name="oxidCopy" value="[{$oxid}]">
    <input type="hidden" name="cl" value="order_overview">
    <input type="hidden" name="language" value="[{$actlang}]">
</form>

[{if $isUnzerPaymentOrder}]

    [{if isset($unzer_success_message)}]
        <div class="messagebox">
            [{$unzer_success_message}]
        </div>
    [{/if}]

    [{if isset($unzer_error_message)}]
        <p class="messagebox messagebox_warning">
            [{$unzer_error_message}]
        </p>
    [{/if}]

    <script>
        document.addEventListener("DOMContentLoaded", function () {
            // Ausblendung von Messageboxen
            const messageboxes = document.querySelectorAll(".messagebox");
            if (messageboxes.length > 0) {
                setTimeout(() => {
                    messageboxes.forEach((box) => {
                        box.style.transition = "opacity 0.5s ease";
                        box.style.opacity = "0";
                        setTimeout(() => {
                            box.style.display = "none";
                        }, 500);
                    });
                }, 5000);
            }

            const unzer_cancel_payment_btn = document.getElementById('unzer_cancel_payment_btn');
            if (unzer_cancel_payment_btn) {
                unzer_cancel_payment_btn.addEventListener('click', function() {
                    let entered_amount = document.getElementById('unzer-capture-amount-input').value;
                    document.getElementById('unzer-cancel-amount-input').value = entered_amount;
                    if (!document.getElementById('unzerpaymentTransactionsActions').checkValidity()) {
                        document.getElementById('unzerpaymentTransactionsActions').reportValidity();
                    } else {
                        document.getElementById('unzer_cancel_payment_btn_hidden').click();
                    }
                });
            }
        });
    </script>

    [{if $unzer_transactions}]
        <script>
            function getUnzerConfirmString(textstr, inputfld, prefix, suffix) {
                let amount = document.getElementById(inputfld).value;
                let formattedAmount = new Intl.NumberFormat(navigator.language, {
                    style: 'currency',
                    currency: document.getElementById('unzer_currency').value
                }).format(amount);
                return textstr + prefix + formattedAmount + suffix;
            }
        </script>

        <table width="100%">
            <tr>
                <td colspan="2">
                    [{if $isLegacyUnzerPaymentOrder}]
                    <p><strong>[{oxmultilang ident="UNZER_LEGACY_ORDER_INFO"}]</strong></p>
                    [{/if}]
                    <input type="hidden" name="unzer_currency" id="unzer_currency" value="[{$unzer_transactions.currency}]">
                </td>
            </tr>

            <tr>
                <td width="50%" style="vertical-align: top">
                    <table class="unzer_table unzer_table_transactions">
                        <tr><th>Short-ID</th><td>[{$unzer_transactions.shortID}]</td></tr>
                        <tr><th>Pay-ID</th><td>[{$unzer_transactions.id}]</td></tr>
                        <tr><th>[{oxmultilang ident="UNZER_STATUS"}]</th><td>[{$unzer_transactions.status}]</td></tr>
                        <tr><th>[{oxmultilang ident="UNZER_TOTAL_AMOUNT"}]</th><td>[{$unzer_transactions.amount}]</td></tr>
                        <tr><th>[{oxmultilang ident="UNZER_CHARGED_AMOUNT"}]</th><td>[{$unzer_transactions.charged}]</td></tr>
                        <tr><th>[{oxmultilang ident="UNZER_CANCELLED_AMOUNT"}]</th><td>[{$unzer_transactions.cancelled}]</td></tr>
                        <tr><th>[{oxmultilang ident="UNZER_REMAINING_AMOUNT"}]</th><td>[{$unzer_transactions.remaining}]</td></tr>

                        [{if !$unzerNoActionsBecauseError}]
                            [{if $unzer_transactions.remainingPlain && $unzer_transactions.paymentBaseMethod neq 'p24'}]
                                <tr>
                                    <td colspan="2">
                                        <form id="unzerpaymentTransactionsActions" method="post" action="[{$oViewConf->getSelfLink()}]" onsubmit="return confirm(getUnzerConfirmString('[{oxmultilang ident="UNZER_CONFIRM_ACTION_CAPTURE"}]', 'unzer-capture-amount-input', '', ''))">
                                            [{$oViewConf->getHiddenSid()}]
                                            <input type="hidden" name="oxid" value="[{$oxid}]">
                                            <input type="hidden" name="oxidCopy" value="[{$oxid}]">
                                            <input type="hidden" name="cl" value="unzer_payment_admin_order">
                                            <input type="hidden" name="fnc" value="executeCapture">
                                            <input type="hidden" name="language" value="[{$actlang}]">
                                            <input type="number" step="0.01" min="0.01" max="[{$unzer_transactions.remainingPlain}]" value="[{$unzer_transactions.remainingPlain}]" name="unzer_capture_amount" id="unzer-capture-amount-input" />
                                            [{if $unzer_transactions.paymentBaseMethod neq 'ppy'}]
                                                <button class="saveButton btn btn-primary btn-sm btn-capture" type="submit" name="unzer_action" value="unzer_capture">
                                                    [{oxmultilang ident="UNZER_CAPTURE_AMOUNT"}]
                                                </button>
                                            [{/if}]
                                            [{if $unzer_transactions.canCancel && $unzer_transactions.paymentBaseMethod neq 'p24'}]
                                                <button class="saveButton btn btn-primary btn-sm btn-cancel" type="button" id="unzer_cancel_payment_btn" name="unzer_cancel_payment" value="unzer_cancel_payment_action">
                                                    [{oxmultilang ident="UNZER_CANCEL_ORDER"}]
                                                </button>
                                            [{/if}]
                                        </form>
                                    </td>
                                </tr>
                            [{/if}]

                            [{if $unzer_transactions.chargedPlain}]
                                <tr>
                                    <td colspan="2">
                                        <form id="unzerpaymentTransactionsActions2" method="post" action="[{$oViewConf->getSelfLink()}]" onsubmit="return confirm(getUnzerConfirmString('[{oxmultilang ident="UNZER_CONFIRM_ACTION_REFUND"}]', 'unzer-refund-amount-input', '', ''))">
                                            [{$oViewConf->getHiddenSid()}]
                                            <input type="hidden" name="oxid" value="[{$oxid}]">
                                            <input type="hidden" name="oxidCopy" value="[{$oxid}]">
                                            <input type="hidden" name="cl" value="unzer_payment_admin_order">
                                            <input type="hidden" name="fnc" value="executeRefund">
                                            <input type="hidden" name="language" value="[{$actlang}]">
                                            <input type="number" step="0.01" min="0.01" max="[{$unzer_transactions.chargedPlain}]" value="[{$unzer_transactions.chargedPlain}]" name="unzer_refund_amount" id="unzer-refund-amount-input" />
                                            <button class="saveButton btn btn-primary btn-sm btn-refund" type="submit" name="unzer_action" value="unzer_refund">
                                                [{oxmultilang ident="UNZER_REFUND_AMOUNT"}]
                                            </button>
                                        </form>
                                    </td>
                                </tr>
                            [{/if}]
                        [{/if}]
                    </table>
                </td>

                <td width="50%" style="vertical-align: top">
                    <table class="unzer_table unzer_table_transactions">
                        <thead>
                        <tr>
                            <th>[{oxmultilang ident="UNZER_TIME"}]</th>
                            <th>[{oxmultilang ident="UNZER_TYPE"}]</th>
                            <th>[{oxmultilang ident="UNZER_ID"}]</th>
                            <th>[{oxmultilang ident="UNZER_AMOUNT"}]</th>
                            <th>[{oxmultilang ident="UNZER_STATUS"}]</th>
                        </tr>
                        </thead>
                        <tbody>
                        [{foreach from=$unzer_transactions.transactions item=unzer_transaction}]
                            <tr>
                                <td>[{$unzer_transaction.time}]</td>
                                <td>[{$unzer_transaction.type}]</td>
                                <td>[{$unzer_transaction.id}]</td>
                                <td>[{$unzer_transaction.amount}]</td>
                                <td>[{$unzer_transaction.status}]</td>
                            </tr>
                            [{/foreach}]
                        </tbody>
                    </table>
                </td>
            </tr>
        </table>

        [{if $unzer_transactions.canCancel && $unzer_transactions.paymentBaseMethod neq 'p24'}]
            <form id="unzerpaymentTransactionsActions3" method="post" action="[{$oViewConf->getSelfLink()}]" onsubmit="return confirm(getUnzerConfirmString('[{oxmultilang ident="UNZER_CONFIRM_ACTION_CANCEL"}]', 'unzer-cancel-amount-input', '', ''))" style="display:none;">
                [{$oViewConf->getHiddenSid()}]
                <input type="hidden" name="oxid" value="[{$oxid}]">
                <input type="hidden" name="oxidCopy" value="[{$oxid}]">
                <input type="hidden" name="cl" value="unzer_payment_admin_order">
                <input type="hidden" name="fnc" value="executeCancel">
                <input type="hidden" name="language" value="[{$actlang}]">
                <input type="number" step="0.01" min="0.01" max="[{$unzer_transactions.remainingPlain}]" value="[{$unzer_transactions.remainingPlain}]" name="unzer_cancel_amount" id="unzer-cancel-amount-input" />
                <button class="saveButton btn btn-primary btn-sm btn-cancel" type="submit" id="unzer_cancel_payment_btn_hidden" name="unzer_cancel_payment" value="unzer_cancel_payment_action">
                    [{oxmultilang ident="UNZER_CANCEL_ORDER"}]
                </button>
            </form>
        [{/if}]

        [{if isset($additionalUnzerPaymentInformation)}]
            [{$additionalUnzerPaymentInformation}]
        [{/if}]

    [{/if}]
[{else}]
    <p>[{oxmultilang ident="NO_UNZER_PAYMENT_ORDER"}]</p>
[{/if}]
