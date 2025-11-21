
[{capture assign="unzerTransferText"}][{oxmultilang ident="UNZER_PLEASE_TRANSFER"}][{/capture}]
<p>
    [{$unzerTransferText|sprintf:$unzer_amount:$unzer_currency}]
</p>

<p>
    [{oxmultilang ident="UNZER_HOLDER"}]: [{$unzer_account_holder}] <br>
    [{oxmultilang ident="UNZER_IBAN"}]: [{$unzer_account_iban}] <br>
    [{oxmultilang ident="UNZER_BIC"}]: [{$unzer_account_bic}] <br>
    [{oxmultilang ident="UNZER_PLEASE_USE_DESCRIPTOR"}]: [{$unzer_account_descriptor}] <br>
</p>
