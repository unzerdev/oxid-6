[{if isset($unzerPaymentId)}]
    <p style="font-style: italic">
        Unzer Payment-ID: [{$unzerPaymentId}]<br>
        Unzer Short-ID: [{$unzerShortId}]
    </p>
[{/if}]

[{if isset($needsUnzerPaymentInfo)}]
    [{$unzerPaymentInfo}]
[{/if}]

[{$smarty.block.parent}]
