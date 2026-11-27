[{if $oViewConf->isExpressCheckout()}]
    <form action="[{$oViewConf->getSslSelfLink()}]" method="post" class="form-group">
        [{$oViewConf->getHiddenSid()}]
        <input type="hidden" name="cl" value="payment">
        <input type="hidden" name="fnc" value="unzerEndExpressCheckout">
        <button type="submit" class="btn btn-primary">[{oxmultilang ident="UNZER_END_EXPRESS_CHECKOUT"}]</button>
    </form>
[{/if}]
[{$smarty.block.parent}]
