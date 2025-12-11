
[{if $oView->isUnzerPaymentModuleConfig()}]

    <style>
        .messagebox_warning {
            border-color: red;
            background: #fdd;
            color: red;
        }
        a.saveButton {
            text-decoration: none;
        }
    </style>

    [{if isset($unzer_success_message)}]
        <p class="messagebox">
            [{$unzer_success_message}]
        </p>
    [{/if}]

    [{if isset($unzer_config_error)}]
        <p class="messagebox messagebox_warning">
            [{$unzer_config_error}]
        </p>
    [{/if}]

    <script>
        document.addEventListener("DOMContentLoaded", function () {
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

            const checkboxWrapper = document.getElementById('unzer_payment_set_method_status_checkbox_p');
            const targetSubmit = document.querySelector('input.confinput[name="save"]');

            if (checkboxWrapper && targetSubmit && targetSubmit.parentNode) {
                targetSubmit.parentNode.insertBefore(checkboxWrapper, targetSubmit);
                checkboxWrapper.style.display = 'block';
            }

            [{if !$unzer_has_clicktopay}]
            const ctp_input = document.querySelector('input[name="confbools[UnzerPaymentClickToPay]"]');
            if (ctp_input) {
                const dl = ctp_input.closest('dl');
                if (dl) {
                    dl.style.display = 'none';
                }
            }
            [{/if}]
        });
    </script>

    <input type="hidden" value="1" name="is_unser_config_update">
    <p id="unzer_payment_set_method_status_checkbox_p" style="display: none">
        <input type="checkbox" value="1" name="unzer_payment_set_method_status"> Update payment methods as configured for your key pair
    </p>

[{/if}]

[{$smarty.block.parent}]

[{if $oView->isUnzerPaymentModuleConfig()}]
    [{if isset($unzer_webhooks)}]

        <h4>[{oxmultilang ident="UNZER_WEBHOOKS"}]</h4>

        <div id="webhooksListing">
            <table class="table">
                <thead>
                <tr>
                    <th>[{oxmultilang ident="UNZER_ID"}]</th>
                    <th>[{oxmultilang ident="UNZER_WEBHOOK_EVENT"}]</th>
                    <th>[{oxmultilang ident="UNZER_WEBHOOK_URL"}]</th>
                    <th>&nbsp;</th>
                </tr>
                </thead>
                <tbody>
                [{assign var="counter" value=0}]
                [{foreach from=$unzer_webhooks item=webhook}]
                    [{assign var="counter" value=$counter+1}]
                    [{cycle values="listitem,listitem2" assign="zebra"}]
                    <tr>
                        <td class="[{$zebra}]">
                            [{$webhook->getId()}]
                        </td>
                        <td class="[{$zebra}]">
                            [{$webhook->getEvent()}]
                        </td>
                        <td class="[{$zebra}]">
                            [{$webhook->getUrl()}]
                        </td>
                        <td class="[{$zebra}]">
                            <a href="[{$oViewConf->getSelfLink()}]&oxid=[{$oModule->getInfo('id')}]&editval[oxshops__oxid]=[{$oxid}]&cl=module_config&fnc=deletewebhook&webhookId=[{$webhook->getId()}]"
                               onclick="return confirm('[{oxmultilang ident="UNZER_WEBHOOK_DELETE_CONFIRM"}]')" class="delete">
                            </a>
                        </td>
                    </tr>
                    [{/foreach}]
                </tbody>
            </table>

            <p>
                <a href="[{$oViewConf->getSelfLink()}]&oxid=[{$oModule->getInfo('id')}]&editval[oxshops__oxid]=[{$oxid}]&cl=module_config&fnc=createwebhook"
                   class="saveButton"
                   onclick="return confirm('[{oxmultilang ident="UNZER_WEBHOOK_CREATE_CONFIRM"}]')">
                    [{oxmultilang ident="UNZER_CREATE_WEBHOOK"}]
                </a>
            </p>

        </div>

    [{/if}]
[{/if}]

