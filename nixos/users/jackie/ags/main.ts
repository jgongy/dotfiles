import { forMonitors } from "lib/utils";
import { Bar } from "widgets/bar/Bar";
import { NotificationPopups } from "widgets/notifications/notificationPopups";

App.config({
    windows: () => [
        ...forMonitors(NotificationPopups),
        Bar,
    ]
})
