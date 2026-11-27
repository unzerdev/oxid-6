[{$smarty.block.parent}]
[{assign var="unzerCartPrice" value=$oxcmp_basket->getPrice()}]
[{if $unzerCartPrice}]<div class="unzer_mini_express_area" data-amount="[{$unzerCartPrice->getBruttoPrice()}]"></div>[{/if}]
