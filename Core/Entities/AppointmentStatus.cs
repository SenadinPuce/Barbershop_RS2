using System.Runtime.Serialization;

namespace Core.Entities
{
    public enum AppointmentStatus
    {
        [EnumMember(Value = "Free")]
        Free,
        [EnumMember(Value = "Reserved")]
        Reserved,
        [EnumMember(Value = "Completed")]
        Completed
    }
}