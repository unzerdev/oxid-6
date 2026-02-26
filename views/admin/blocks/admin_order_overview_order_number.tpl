[{$smarty.block.parent}]

[{assign var="isUnzerPayment" value=$edit->oxorder__oxpaymenttype->value|stripos:"up_"}]
[{if $isUnzerPayment !== false}]
    [{if $edit->oxorder__oxunzerpayordernr->value}]
        <b>[{oxmultilang ident='UNZER_ORDERNR' suffix='COLON'}] </b>[{$edit->oxorder__oxunzerpayordernr->value}]<br>
    [{/if}]
[{/if}]