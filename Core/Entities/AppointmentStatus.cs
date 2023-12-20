using System.Runtime.Serialization;

namespace Core.Entities
{
    public enum AppointmentStatus
    {
        [EnumMember(Value = "Free")]
        Free,
        [EnumMember(Value = "Waiting")]
        Waiting,
        [EnumMember(Value = "Canceled")]
        Canceled,
        [EnumMember(Value = "Confirmed")]
        Confirmed,
        [EnumMember(Value = "Completed")]
        Completed
    }
}