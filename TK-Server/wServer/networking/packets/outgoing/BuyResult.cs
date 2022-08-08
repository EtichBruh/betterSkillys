﻿using common;

namespace wServer.networking.packets.outgoing
{
    public enum BuyResultType
    {
        Success = 0,
        NotEnoughGold = 1,
        NotEnoughFame = 2
    }

    public class BuyResult : OutgoingMessage
    {
        public const int Success = 0;
        public const int Dialog = 1;

        public int Result { get; set; }
        public string ResultString { get; set; }

        public override PacketId MessageId => PacketId.BUYRESULT;

        protected override void Write(NWriter wtr)
        {
            wtr.Write(Result);
            wtr.WriteUTF(ResultString);
        }
    }
}
