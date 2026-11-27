[{$smarty.block.parent}]
[{assign var="unzerModalPrice" value=$oxcmp_basket->getPrice()}]
[{if $unzerModalPrice}]
    <div class="unzer_modal_express_area" data-amount="[{$unzerModalPrice->getBruttoPrice()}]"></div>
[{/if}]
