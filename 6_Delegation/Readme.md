Delegatecall

<設計目的>
使用給定地址的code，其他訊息則使用當前合約（存儲、餘額）

<機制>
DELEGATECALL 和 CALL 都是 Solidity 內建提供的函數，用來實現合約間的相互調用。兩者的差別在於， CALL 會將執行環境搬移到被呼叫者合約，而 DELEGATECALL 則是在呼叫者合約的環境下運行（更簡單的解釋：CALL 是把資料丟給下個合約讓他執行；DELEGATECALL 是把被呼叫者的程式碼抓回來插進自己合約運行）。使用 DELEGATECALL 時，msg.sender 和 msg.value 的值不會改變。