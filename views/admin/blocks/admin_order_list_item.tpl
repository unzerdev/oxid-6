[{assign var="isUnzerPayment" value=$listitem->oxorder__oxpaymenttype->value|stripos:"up_"}]
[{if $isUnzerPayment !== false}]
    [{$smarty.block.parent}]
    <script type="text/javascript">
        var elements = document.getElementsByClassName("order_no");
        var unzer_order = elements[elements.length-1].getElementsByTagName("a");
        unzer_order[0].innerHTML = "[{$listitem->oxorder__oxordernr->value}] [{if $listitem->oxorder__oxunzerpayordernr->value}] ([{oxmultilang ident='UNZER_ORDERNR' suffix='COLON'}] [{$listitem->oxorder__oxunzerpayordernr->value}][{/if}]";
    </script>
[{else}]
    [{$smarty.block.parent}]
[{/if}]