[{$smarty.block.parent}]
[{if $oViewConf->getTopActiveClassName() != "order" && $oViewConf->isUnzerExpressEnabled()}]
    <script type="module" src="https://static-v2.unzer.com/v2/ui-components/index.js"></script>
<style>
    #basketModal .unzer_modal_express_area:not(:empty) {
        padding: 0 15px 15px;
    }
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
</script>
<script defer src="[{$oViewConf->getModuleUrl('unzer_payment', 'assets/js/unzer-express.js')|escape}]"></script>
[{/if}]