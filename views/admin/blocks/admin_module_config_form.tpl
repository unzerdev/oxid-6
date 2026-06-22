
[{if $oView->isUnzerPaymentModuleConfig()}]

    <script type="text/javascript">
        (function () {
            function getInputValue(name) {
                var el = document.querySelector('[name="' + name + '"]');
                return el ? el.value : '';
            }

            function getCheckboxValue(name) {
                var el = document.querySelector('input[type="checkbox"][name="' + name + '"]');
                return !!(el && el.checked);
            }

            function buildPreviewPayload() {
                return {
                    shopName: getInputValue('confstrs[sUnzerPaymentDesignShopName]'),
                    basketBackgroundColor: getInputValue('confstrs[sUnzerPaymentDesignBasketBackgroundColor]'),
                    paymentFormBackgroundColor: getInputValue('confstrs[sUnzerPaymentDesignPaymentFormBackgroundColor]'),
                    font: getInputValue('confselects[sUnzerPaymentDesignFont]'),
                    brandColor: getInputValue('confstrs[sUnzerPaymentDesignBrandColor]'),
                    shadows: getCheckboxValue('confbools[blUnzerPaymentDesignShadows]'),
                    textColor: getInputValue('confstrs[sUnzerPaymentDesignTextColor]'),
                    linkColor: getInputValue('confstrs[sUnzerPaymentDesignLinkColor]'),
                    cornerRadius: getInputValue('confstrs[sUnzerPaymentDesignCornerRadius]'),
                    hideUnzerLogo: getCheckboxValue('confbools[blUnzerPaymentDesignHideUnzerLogo]'),
                    logoImage: getInputValue('confstrs[sUnzerPaymentDesignLogoImage]'),
                    footerColor: getInputValue('confstrs[sUnzerPaymentDesignFooterColor]'),
                    headerColor: getInputValue('confstrs[sUnzerPaymentDesignHeaderColor]'),
                    hideBasket: getCheckboxValue('confbools[blUnzerPaymentDesignHideBasket]')
                };
            }

            function findDesignGroupContent() {
                var marker = document.querySelector('[name="confstrs[sUnzerPaymentDesignShopName]"]');

                if (!marker) {
                    return null;
                }

                var groupExp = marker.closest('.groupExp');
                if (!groupExp) {
                    return null;
                }

                return groupExp.querySelector(':scope > div') || groupExp.querySelector('div');
            }

            function insertPreviewIntoDesignGroup(wrapper) {
                var content = findDesignGroupContent();

                if (!content) {
                    return false;
                }

                var lastField = content.querySelector('input[type="text"][name="confstrs[sUnzerPaymentDesignPaymentFormBackgroundColor]"]')
                    || content.querySelector('[name="confstrs[sUnzerPaymentDesignPaymentFormBackgroundColor]"]');

                if (!lastField) {
                    content.appendChild(wrapper);
                    return true;
                }

                var lastDl = lastField.closest('dl');
                if (lastDl && lastDl.parentNode) {
                    lastDl.insertAdjacentElement('afterend', wrapper);
                    return true;
                }

                content.appendChild(wrapper);
                return true;
            }

            function createPreviewArea() {
                if (document.getElementById('unzer-preview-wrapper')) {
                    return;
                }

                var wrapper = document.createElement('dl');
                wrapper.id = 'unzer-preview-wrapper';
                wrapper.style.margin = '12px 0 8px 0';
                wrapper.style.padding = '14px 16px';
                wrapper.style.border = '1px solid #d9d9d9';
                wrapper.style.background = '#f9f9f9';

                var title = document.createElement('div');
                title.textContent = 'Unzer Preview';
                title.style.fontWeight = 'bold';
                title.style.marginBottom = '10px';

                var button = document.createElement('button');
                button.type = 'button';
                button.id = 'unzer-preview-button';
                button.className = 'btn';
                button.textContent = 'Open Unzer Preview';
                button.style.marginRight = '10px';

                var status = document.createElement('span');
                status.id = 'unzer-preview-status';
                status.style.color = '#555';

                var default_hint = document.createElement('p');
                default_hint.textContent = 'If you want to reset to unzer default values, just clear the input to an empty value.';

                button.addEventListener('click', function () {
                    status.textContent = 'Creating preview...';
                    button.disabled = true;

                    var payload = buildPreviewPayload();
                    var url = '[{$oViewConf->getSelfLink()|replace:"&amp;":"&"}]cl=unzer_payment_admin_preview&fnc=createPreview';

                    fetch(url, {
                        method: 'POST',
                        credentials: 'same-origin',
                        headers: {
                            'Content-Type': 'application/json',
                            'X-Requested-With': 'XMLHttpRequest'
                        },
                        body: JSON.stringify(payload)
                    })
                        .then(function (response) {
                            return response.json();
                        })
                        .then(function (data) {
                            button.disabled = false;

                            if (data && data.success && data.previewUrl) {
                                status.textContent = 'Preview created.';
                                window.open(data.previewUrl, '_blank');
                                return;
                            }

                            status.textContent = data && data.message ? data.message : 'Preview could not be created.';
                        })
                        .catch(function () {
                            button.disabled = false;
                            status.textContent = 'Technical error while creating preview.';
                        });
                });

                wrapper.appendChild(title);
                wrapper.appendChild(button);
                wrapper.appendChild(status);
                wrapper.appendChild(default_hint);

                insertPreviewIntoDesignGroup(wrapper);
            }

            document.addEventListener('DOMContentLoaded', function () {
                createPreviewArea();
            });
        })();
    </script>

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
                [{if $unzer_webhooks neq false}]
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
                [{/if}]
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

