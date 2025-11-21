[{if $oxid|substr:0:3 == 'up_'}]
    <tr>
        <td colspan="2">
            <p>
                <strong>
                    Unzer Payment
                </strong>
            </p>
        </td>
    </tr>
    [{/if}]

[{$smarty.block.parent}]
