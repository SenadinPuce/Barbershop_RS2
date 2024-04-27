using System.Runtime.Serialization;

namespace Core.Entities
{
    public enum AppointmentStatus
    {
        Free,
        [EnumMember(Value = "Reserved")]
        Reserved,
        [EnumMember(Value = "Completed")]
        Completed,
        [EnumMember(Value = "Canceled")]
        Canceled
    }
}