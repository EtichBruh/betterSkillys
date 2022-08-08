﻿using common;

namespace wServer.networking.packets.outgoing
{
    public class TradeDone : OutgoingMessage
    {
        public int Code { get; set; }
        public string Description { get; set; }

        public override PacketId MessageId => PacketId.TRADEDONE;

        protected override void Write(NWriter wtr)
        {
            wtr.Write(Code);
            wtr.WriteUTF(Description);
        }
    }
}
