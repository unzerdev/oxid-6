[{$smarty.block.parent}]

<script type="text/javascript">
    if (!window.unzerModuleColorPickerInitialized) {
        window.unzerModuleColorPickerInitialized = true;

        document.addEventListener('DOMContentLoaded', function () {
            var selector = 'input[type="text"][name^="confstrs[sUnzerPaymentDesign"]';
            var textInputs = document.querySelectorAll(selector);

            function normalizeHex(value) {
                if (!value) {
                    return '#000000';
                }

                value = value.trim();

                if (!/^#([0-9a-fA-F]{6})$/.test(value)) {
                    return '#000000';
                }

                return value;
            }

            textInputs.forEach(function (textInput) {
                var allowedNames = {
                    'confstrs[sUnzerPaymentDesignBasketBackgroundColor]': true,
                    'confstrs[sUnzerPaymentDesignPaymentFormBackgroundColor]': true,
                    'confstrs[sUnzerPaymentDesignBrandColor]': true,
                    'confstrs[sUnzerPaymentDesignTextColor]': true,
                    'confstrs[sUnzerPaymentDesignLinkColor]': true,
                    'confstrs[sUnzerPaymentDesignFooterColor]': true,
                    'confstrs[sUnzerPaymentDesignHeaderColor]': true
                };

                if (!allowedNames[textInput.name] || textInput.dataset.unzerColorEnhanced === '1') {
                    return;
                }

                textInput.dataset.unzerColorEnhanced = '1';

                var wrapper = document.createElement('span');
                wrapper.style.display = 'inline-flex';
                wrapper.style.alignItems = 'center';
                wrapper.style.gap = '8px';
                wrapper.style.marginLeft = '8px';

                var colorInput = document.createElement('input');
                colorInput.type = 'color';
                colorInput.value = normalizeHex(textInput.value);
                colorInput.style.width = '42px';
                colorInput.style.height = '28px';
                colorInput.style.padding = '0';
                colorInput.style.border = '1px solid #ccc';
                colorInput.style.cursor = 'pointer';

                colorInput.addEventListener('input', function () {
                    textInput.value = colorInput.value;
                });

                textInput.addEventListener('input', function () {
                    if (/^#([0-9a-fA-F]{6})$/.test(textInput.value.trim())) {
                        colorInput.value = textInput.value.trim();
                    }
                });

                wrapper.appendChild(colorInput);
                textInput.parentNode.insertBefore(wrapper, textInput.nextSibling);
            });
        });
    }
</script>