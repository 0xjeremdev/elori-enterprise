from django.db import models


class Files(models.Model):

    content = models.BinaryField()
    name = models.CharField(max_length=500, blank=False, null=False)
    file_type = models.CharField(max_length=500, blank=False, null=False)
    size = models.IntegerField(default=0)
    created_at = models.DateTimeField(auto_now_add=True)
    updated_at = models.DateTimeField(auto_now=True)

    class Meta:
        verbose_name = "Files"
        ordering = ["-created_at"]

    def __str__(self):
        return self.name

    @classmethod
    def create(cls, file):
        if not file:
            return None
        file_obj = cls(content=file.read(),
                       name=file.name,
                       file_type=file.content_type,
                       size=file.size)
        file_obj.save()
        return file_obj

    def update(self, file):
        self.name = file.name
        self.content = file.read()
        self.file_type = file.content_type
        self.size = file.size
        self.save()